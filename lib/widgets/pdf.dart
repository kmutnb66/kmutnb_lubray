import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  String? title;
  String? path;
  ViewPdf({this.title,this.path});

  @override
  _ViewPdf createState() => _ViewPdf();
}

class _ViewPdf extends State<ViewPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!,style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SfPdfViewer.network(
        widget.path!,
        key: _pdfViewerKey,
      ),
    );
  }
}