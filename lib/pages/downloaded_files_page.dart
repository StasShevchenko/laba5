import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:laba5/pages/components/file_list_item.dart';

class DownloadedFilesPage extends StatefulWidget {
  const DownloadedFilesPage({super.key});

  @override
  State<DownloadedFilesPage> createState() => _DownloadedFilesPageState();
}

class _DownloadedFilesPageState extends State<DownloadedFilesPage> {
  final directory = '/storage/emulated/0/Download/AppArticles';
  List _files = [];

  @override
  void initState() {
    getFiles();
  }

  void getFiles() {
    setState(() {
      _files = io.Directory(directory).listSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Скачанные файлы'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) => FileListItem(file: _files[index])),
        ),
      ),
    );
  }
}
