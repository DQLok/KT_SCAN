import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class ScanDocPage extends StatefulWidget {
  const ScanDocPage({super.key});

  @override
  State<ScanDocPage> createState() => _ScanDocPageState();
}

class _ScanDocPageState extends State<ScanDocPage> {
  File? scannedImage;
  DocumentScanningResult result = DocumentScanningResult(
      pdf: DocumentScanningResultPdf(pageCount: 1, uri: ""), images: []);
  List<String> listValueImg = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      startScan();
    }
  }

  startScan() async {
    DocumentScannerOptions documentScannerOptions = DocumentScannerOptions(
        mode: ScannerMode.full,
        documentFormat: DocumentFormat.jpeg,
        isGalleryImport: true);
    var image = DocumentScanner(options: documentScannerOptions);
    result = await image.scanDocument();
    listValueImg = result.images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: List.generate(listValueImg.length,
            (index) => Text(listValueImg.elementAt(index))),
      ),
    );
  }
}
