import 'dart:typed_data';
import 'package:codajoy/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfTest extends StatefulWidget {
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfTest> {
  Uint8List? pdfBytes;

  @override
  void initState() {
    super.initState();
    _fetchPdf();
  }
LoginController login=Get.put(LoginController());
  Future<void> _fetchPdf() async {
      Future< String ?> authtoken=login.gettoken();
    try {
      final response = await http.get(Uri.parse('http://192.168.42.84:8000/api/v1/auth/File/GETALL',), headers: {'Authorization': 'Bearer $authtoken'},);
      print(response.statusCode);
      if (response.statusCode == 200) {
     
        setState(() {
          pdfBytes = response.bodyBytes;
          print(pdfBytes);
        });
      } else {
         print(pdfBytes);
        throw Exception('Failed to load PDF: ${response.reasonPhrase}');
      }
    } catch (error) {
       print(pdfBytes);
      print('Error fetching PDF: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body:
      pdfBytes==null?
      SfPdfViewer.network(
              'https://perso.univ-lyon1.fr/lionel.medini/enseignement/M1IF13/Cours/pdf/CM_M1IF13_spring.pdf')
       : SfPdfViewer.memory(
              pdfBytes!)
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
        child: SfPdfViewer.memory(
              pdfBytes))
      );
  }
}

