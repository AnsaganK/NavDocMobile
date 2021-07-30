import 'package:flutter/material.dart';
import 'package:nd/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FilePDF extends StatefulWidget {
  final url;
  FilePDF({this.url});

  @override
  _FilePDFState createState() => _FilePDFState();
}

class _FilePDFState extends State<FilePDF> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        title: const Text('Открытие файла'),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
      ),
    );
  }
}
