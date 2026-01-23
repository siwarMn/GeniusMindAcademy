import 'dart:io';
import 'dart:typed_data';
import 'package:codajoy/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Test screen for PDF viewing (uses FREE flutter_pdfview)
class PdfTest extends StatefulWidget {
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfTest> {
  String? localFilePath;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPdf();
  }

  LoginController login = Get.put(LoginController());

  Future<void> _fetchPdf() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      String? authtoken = await login.gettoken();

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/v1/auth/File/GETAll'),
        headers: {'Authorization': 'Bearer $authtoken'},
      );

      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Save to temp file for flutter_pdfview
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/test_pdf.pdf';
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(response.bodyBytes);

        setState(() {
          localFilePath = tempPath;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load PDF: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching PDF: $error');
      setState(() {
        errorMessage = 'Error: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer Test'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Chargement du PDF..."),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPdf,
              child: Text("Reessayer"),
            ),
          ],
        ),
      );
    }

    if (localFilePath != null) {
      return PDFView(
        filePath: localFilePath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      );
    }

    return Center(child: Text("Aucun PDF a afficher"));
  }

  @override
  void dispose() {
    // Clean up temp file
    if (localFilePath != null) {
      try {
        File(localFilePath!).delete();
      } catch (e) {}
    }
    super.dispose();
  }
}

// Preview widget for showing PDF in a container
class PdfPreview extends StatefulWidget {
  final Uint8List pdfBytes;

  PdfPreview({required this.pdfBytes});

  @override
  State<PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreview> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _saveToFile();
  }

  Future<void> _saveToFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/preview_${DateTime.now().millisecondsSinceEpoch}.pdf';
    File tempFile = File(tempPath);
    await tempFile.writeAsBytes(widget.pdfBytes);
    setState(() {
      localFilePath = tempPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (localFilePath == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: PDFView(
          filePath: localFilePath!,
          enableSwipe: true,
          autoSpacing: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (localFilePath != null) {
      try {
        File(localFilePath!).delete();
      } catch (e) {}
    }
    super.dispose();
  }
}
