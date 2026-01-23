import 'dart:io';
import 'dart:typed_data';
import 'package:codajoy/services/courses_service.dart';
import 'package:codajoy/services/download_service.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// Screen to view PDF files
class PdfViewerScreen extends StatefulWidget {
  final int fileId;
  final String title;

  const PdfViewerScreen({
    Key? key,
    required this.fileId,
    required this.title,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final CoursesService _service = CoursesService();

  String? localFilePath;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  // Load the PDF from backend
  Future<void> _loadPdf() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get PDF bytes from backend
      Uint8List? bytes = await _service.getPdfFile(widget.fileId);

      if (bytes != null && bytes.isNotEmpty) {
        // Save to temp file (flutter_pdfview needs a file path)
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/temp_${widget.fileId}.pdf';
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(bytes);

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
        title: Text(widget.title, style: TextStyle(fontSize: 16)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Download button
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              DownloadService().downloadPdf(widget.fileId, widget.title);
            },
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPdf,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: localFilePath != null ? _buildPageNavigator() : null,
    );
  }

  Widget _buildBody() {
    // Loading
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text("Chargement..."),
          ],
        ),
      );
    }

    // Error
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPdf,
              child: Text("Reessayer"),
            ),
          ],
        ),
      );
    }

    // PDF Viewer
    if (localFilePath != null) {
      return PDFView(
        filePath: localFilePath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onRender: (pages) {
          setState(() => totalPages = pages ?? 0);
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page ?? 0;
            totalPages = total ?? 0;
          });
        },
        onError: (error) {
          setState(() => errorMessage = error.toString());
        },
      );
    }

    return Center(child: Text("Aucun PDF"));
  }

  // Page navigator at bottom
  Widget _buildPageNavigator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Page ${currentPage + 1} / $totalPages",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
