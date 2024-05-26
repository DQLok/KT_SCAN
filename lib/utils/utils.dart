import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:techable/utils/dice_formula.dart';
import 'package:techable/utils/levenshtein_formula.dart';
import 'package:techable/utils/regex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}

Future<String> getLocalTemporaryPath(String path) async {
  return '${(await getTemporaryDirectory()).path}/$path';
}

Future<String> getLocalPathCache(String path) async {
  return '${(await getApplicationCacheDirectory()).path}/$path';
}

//compare 2 string
bool comapreTwoStringCus(String text1, String text2) {
  if (text1.isEmpty || text2.isEmpty) return false;
  text1 = removeVietnameseAccent(text1.trim().toLowerCase());
  text2 = removeVietnameseAccent(text2.trim().toLowerCase());
  bool checkMax = max(DiceFormula.maxRating(text1, [text2]),
              LevenshteinFormula.maxRating(text1, [text2])) >
          0.5
      ? true
      : false || text1.contains(text2);
  return checkMax;
}

int convertPrice(String text) {
  if (text.isEmpty) return -1;
  text = removeChartGetOnlyNumber(text);
  if (text.isEmpty) return -1;
  int? result = int.tryParse(text);
  return result ?? -1;
}
