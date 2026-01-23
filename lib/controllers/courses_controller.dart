import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// Simple PDF viewer widget (legacy - kept for backward compatibility)
// For new code, use PdfViewerScreen instead
// Uses flutter_pdfview which is FREE
class PdfViewer extends StatefulWidget {
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  String? localFilePath;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadSamplePdf();
  }

  // Load a sample PDF from internet
  Future<void> _loadSamplePdf() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Download sample PDF
      final response = await http.get(
        Uri.parse('https://www.w3.org/WAI/WCAG21/Techniques/pdf/img/table-word.pdf'),
      );

      if (response.statusCode == 200) {
        // Save to temp file
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/sample.pdf';
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(response.bodyBytes);

        setState(() {
          localFilePath = tempPath;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Impossible de charger le PDF";
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        errorMessage = "Erreur: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
            Text("Chargement..."),
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
            Text(errorMessage!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSamplePdf,
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
        onRender: (pages) {
          setState(() {
            totalPages = pages ?? 0;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page ?? 0;
          });
        },
      );
    }

    return Center(child: Text("Aucun PDF"));
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

// Preview widget for showing PDF in a smaller container
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
