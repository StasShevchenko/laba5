import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class FileListItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function onDelete;

  const FileListItem({
    super.key,
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(file.path.split('/')[file.path.split('/').length - 1]),
            )),
            IconButton(
                onPressed: () {
                  OpenFilex.open(file.path);
                },
                icon: Icon(Icons.open_in_new)),
            IconButton(onPressed: () {
              onDelete();
            }, icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
