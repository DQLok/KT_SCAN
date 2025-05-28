import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:techable/views/result_filter/table_filter/utils.dart';

class OcrCell {
  final String text;
  final Rect boundingBox;

  OcrCell({required this.text, required this.boundingBox});
}

String processTableFormat({required List<TextBlock> blocks}) {
  List<List<String>> tableFromTop =
      extractTableDataY(blocks: blocks, fromBottom: false);
  List<List<String>> tableFromBottom =
      extractTableDataY(blocks: blocks, fromBottom: true);

  // Giờ bạn có thể so sánh 2 bảng:
  debugPrint("---------------top-----------");
  for (int i = 0; i < tableFromTop.length; i++) {
    debugPrint('Top: ${tableFromTop[i]}');
  }
  debugPrint("------------bottom--------------");
  for (int i = 0; i < tableFromTop.length; i++) {
    debugPrint('Bottom: ${tableFromBottom[i]}');
  }
  debugPrint("--------------------------");
  return _process(tableFromTop: tableFromTop, tableFromBottom: tableFromBottom);
}

List<List<String>> extractTableDataY(
    {required List<TextBlock> blocks, required bool fromBottom}) {
  final lines = <TextLine>[];
  for (final block in blocks) {
    lines.addAll(block.lines);
  }

  final cells = lines
      .map((line) => OcrCell(text: line.text, boundingBox: line.boundingBox))
      .toList();

  // Gom hàng theo tọa độ y
  cells.sort((a, b) => fromBottom
      ? b.boundingBox.top.compareTo(a.boundingBox.top)
      : a.boundingBox.top.compareTo(b.boundingBox.top));
  const yThreshold = 20;
  final rows = <List<OcrCell>>[];

  for (var cell in cells) {
    bool added = false;
    for (var row in rows) {
      if ((cell.boundingBox.top - row.first.boundingBox.top).abs() <
          yThreshold) {
        row.add(cell);
        added = true;
        break;
      }
    }
    if (!added) rows.add([cell]);
  }

  // Sắp xếp từng hàng theo x
  for (final row in rows) {
    row.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
  }

  // Chuyển sang List<List<String>> mà không thêm '' nếu thiếu cột
  final rawTableData =
      rows.map((row) => row.map((cell) => cell.text).toList()).toList();

  // In log để debug
  for (var row in rawTableData) {
    debugPrint(row.join(' | '));
  }

  return rawTableData;
}

String _process(
    {required List<List<String>> tableFromTop,
    required List<List<String>> tableFromBottom}) {
// Tìm header row chứa "STT"

  final headerRowTop = tableFromTop.firstWhere(
    (row) => row.isNotEmpty && fuzzyMatchToStt(row.first),
    orElse: () => [],
  );

  final headerRowBottom = tableFromBottom.firstWhere(
    (row) => row.isNotEmpty && fuzzyMatchToStt(row.first),
    orElse: () => [],
  );

  debugPrint('Row "STT" từ Top (không dấu): $headerRowTop');
  debugPrint('Row "STT" từ Bottom (không dấu): $headerRowBottom');
  debugPrint('-----------------');

  final totalRowTop = tableFromTop.firstWhere(
    (row) => row.isNotEmpty && fuzzyMatchToTongCong(row.first),
    orElse: () => [],
  );

  final totalRowBottom = tableFromBottom.firstWhere(
    (row) => row.isNotEmpty && fuzzyMatchToTongCong(row.first),
    orElse: () => [],
  );

  debugPrint('Row "Tổng cộng" từ Top (không dấu): $totalRowTop');
  debugPrint('Row "Tổng cộng" từ Bottom (không dấu): $totalRowBottom');
  debugPrint('-----------------');
  final sectionTop = extractSectionBetweenRows(
    table: tableFromTop,
    isStart: fuzzyMatchToStt,
    isEnd: fuzzyMatchToTongCong,
  );

  final sectionBottom = extractSectionBetweenRows(
    table: tableFromBottom,
    isStart: fuzzyMatchToStt,
    isEnd: fuzzyMatchToTongCong,
  );

  debugPrint('--- Section from Top ---');
  for (var row in sectionTop) {
    debugPrint(row.toString());
  }

  debugPrint('--- Section from Bottom ---');
  for (var row in sectionBottom) {
    debugPrint(row.toString());
  }
  debugPrint("----------------");

  List<List<String>> finalTable = mergeSections(sectionTop, sectionBottom);

  // 🔁 Chọn header dài nhất
  final headerRow = headerRowTop.length >= headerRowBottom.length
      ? headerRowTop
      : headerRowBottom;

  // 🔁 Chọn total row dài nhất
  final totalRow = totalRowTop.length >= totalRowBottom.length
      ? totalRowTop
      : totalRowBottom;

  // Nếu finalTable rỗng thì không thể thay header/total, nên kiểm tra trước
  if (finalTable.isEmpty) {
    debugPrint("finalTable rỗng, không thể thay thế header và total.");
    return "";
  }

  // 🔁 Gắn header vào đầu và total vào cuối bằng cách thay thế phần tử
  finalTable[0] = headerRow;
  finalTable[finalTable.length - 1] = totalRow;

  //clean data
  finalTable = formatNumericCellsClean(finalTable);

  // ✅ In kết quả
  debugPrint('=== Final Combined Table ===');
  for (var row in finalTable) {
    debugPrint(row.toString());
  }

  //convert json
  final resultJson = generateJsonFromTable(
    finalTable: finalTable,
    headerRow: finalTable.first,
    totalRowBottom: finalTable.last,
  );

  String textJson = jsonEncode(resultJson);

  debugPrint(textJson);
  return textJson;
}

List<List<String>> mergeSections(
  List<List<String>> sectionTop,
  List<List<String>> sectionBottom,
) {
  if (sectionTop.isEmpty && sectionBottom.isEmpty) return [];

  // 1. So sánh header (dòng đầu tiên)
  final headerTop = sectionTop.isNotEmpty ? sectionTop.first : <String>[];
  final headerBottom =
      sectionBottom.isNotEmpty ? sectionBottom.first : <String>[];
  final betterHeader =
      headerTop.length >= headerBottom.length ? headerTop : headerBottom;

  // 2. So sánh dòng "Tổng cộng" (giả sử là dòng cuối cùng)
  final totalTop = sectionTop.length >= 2 ? sectionTop.last : <String>[];
  final totalBottom =
      sectionBottom.length >= 2 ? sectionBottom.last : <String>[];

  // Kiểm tra dòng "Tổng cộng" có nằm ở đầu dòng không
  final isTotalTopValid =
      totalTop.isNotEmpty && fuzzyMatchToTongCong(totalTop.first);
  final isTotalBottomValid =
      totalBottom.isNotEmpty && fuzzyMatchToTongCong(totalBottom.first);

  final betterTotal = isTotalBottomValid
      ? totalBottom
      : isTotalTopValid
          ? totalTop
          : <String>[];

  // 3. Các dòng ở giữa (bỏ header và total)
  final middleTop = sectionTop.length > 2
      ? sectionTop.sublist(1, sectionTop.length - 1)
      : <List<String>>[];
  final middleBottom = sectionBottom.length > 2
      ? sectionBottom.sublist(1, sectionBottom.length - 1)
      : <List<String>>[];

  final maxLength = middleTop.length > middleBottom.length
      ? middleTop.length
      : middleBottom.length;
  final List<List<String>> mergedMiddleRows = [];

  for (int i = 0; i < maxLength; i++) {
    final rowTop = i < middleTop.length ? middleTop[i] : <String>[];
    final rowBottom = i < middleBottom.length ? middleBottom[i] : <String>[];
    final betterRow = rowTop.length >= rowBottom.length ? rowTop : rowBottom;
    mergedMiddleRows.add(betterRow);
  }

  // 4. Gộp tất cả lại
  final result = <List<String>>[
    betterHeader,
    ...mergedMiddleRows,
    if (betterTotal.isNotEmpty) betterTotal,
  ];

  return result;
}

List<List<String>> formatNumericCellsClean(List<List<String>> table) {
  final RegExp startsWithDigit = RegExp(r'^\d');
  final RegExp keepNumberChars = RegExp(r'[0-9.,]');

  return table.map((row) {
    return row.map((cell) {
      if (startsWithDigit.hasMatch(cell)) {
        // Giữ lại các ký tự số, dấu chấm hoặc dấu phẩy
        final cleaned = cell
            .split('')
            .where((char) => keepNumberChars.hasMatch(char))
            .join();
        return cleaned;
      } else {
        return cell;
      }
    }).toList();
  }).toList();
}

Map<String, dynamic> generateJsonFromTable({
  required List<List<String>> finalTable,
  required List<String> headerRow,
  required List<String> totalRowBottom,
}) {
  // 👉 Tìm vị trí của ô chứa từ "Tổng cộng" trong totalRowBottom
  final indexOfTongCong = totalRowBottom.indexWhere(fuzzyMatchToTongCong);

  // 👉 Lấy giá trị phía sau ô "Tổng cộng", nếu có
  final totalValue =
      (indexOfTongCong != -1 && indexOfTongCong + 1 < totalRowBottom.length)
          ? totalRowBottom[indexOfTongCong + 1]
          : "";

  // 👉 Cắt phần rows từ finalTable, bỏ dòng header (0) và dòng total cuối
  final dataRows = finalTable.sublist(1, finalTable.length - 1);

  // 👉 Tạo danh sách các object từ headerRow và dataRows
  final items = dataRows.map((row) {
    final Map<String, String> item = {};
    for (int i = 0; i < headerRow.length; i++) {
      final key = headerRow[i];
      final value = i < row.length ? row[i] : '';
      item[key] = value;
    }
    return item;
  }).toList();

  return {
    "total": totalValue,
    "items": items,
  };
}
