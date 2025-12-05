import 'dart:typed_data';

import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/services/courses_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  Uint8List? pdfBytes;

  late LoginController login;

  @override
  void initState() {
    super.initState();
    login = Get.put(LoginController());
    _fetchPdf();
  }

  CoursesService coursesService = MockCoursesService();

  Future<void> _fetchPdf() async {
    try {
      final bytes = await coursesService.getPdfFile();
      setState(() {
        pdfBytes = bytes;
      });
    } catch (error) {
      print('Error fetching PDF: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: pdfBytes == null
          ? SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')
          : SfPdfViewer.memory(pdfBytes!),
    );
  }
}

class PdfPreview extends StatelessWidget {
  final Uint8List pdfBytes;

  PdfPreview({required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SfPdfViewer.memory(pdfBytes),
      ),
    );
  }
}
