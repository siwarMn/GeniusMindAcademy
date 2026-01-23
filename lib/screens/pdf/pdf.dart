import 'package:codajoy/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LoginController loginu = Get.put(LoginController());
  Uint8List? pdfBytes; // Variable to hold PDF bytes
  int? _totalPages; // Variable to hold total pages
  int _currentPage = 0; // Variable to track current page
  bool pdfReady = false; // Flag to indicate if PDF is ready for viewing
  PDFViewController? _pdfViewController; // Controller for PDFView widget

  // Function to fetch PDF bytes from URL
  Future<void> getPdfBytes(String url) async {
    Future<String?> authtoken = loginu.gettoken();
    try {
      var headers = {
        'Authorization':
            "Bearer $authtoken", // Replace YourAccessTokenHere with your actual access token
        'Content-Type': 'application/json; charset=utf-8'
      };

      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          pdfBytes = response.bodyBytes; // Set PDF bytes
        });
      } else {
        throw Exception('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error opening URL file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch PDF bytes from URL
    getPdfBytes("http://192.168.42.84:8082/api/v1/auth/file/get").then((_) {
      setState(() {
        pdfReady = true; // Mark PDF as ready for viewing
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: pdfReady // Check if PDF is ready for viewing
          ? PDFView(
              onViewCreated: (PDFViewController vc) {
                setState(() {
                  _pdfViewController = vc; // Set PDF controller
                });
              },
              onPageChanged: (int? page, int? totalPages) {
                setState(() {
                  _currentPage = page!; // Update current page
                  _totalPages = totalPages; // Update total pages
                });
              },
              onRender: (int? totalPages) {
                setState(() {
                  _totalPages = totalPages; // Set total pages
                });
              },
              filePath: null, // Pass null to filePath when using data
              pdfData: pdfBytes, // Pass PDF bytes
            )
          : Center(
              child: CircularProgressIndicator(), // Show loading indicator
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: 50,
            color: Colors.black,
            onPressed: () {
              if (_currentPage > 0) {
                _currentPage--;
                _pdfViewController!
                    .setPage(_currentPage); // Navigate to previous page
              }
            },
          ),
          Text(
            "${_currentPage + 1}/$_totalPages", // Display current page / total pages
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 50,
            color: Colors.black,
            onPressed: () {
              if (_currentPage < _totalPages! - 1) {
                _currentPage++;
                _pdfViewController!
                    .setPage(_currentPage); // Navigate to next page
              }
            },
          ),
        ],
      ),
    );
  }
}
