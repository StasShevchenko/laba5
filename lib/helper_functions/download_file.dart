import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

Future download({required String url, required String filename, required Function(String) onProgressChange,
    required Function onDownloadEnd}) async {
    var savePath = '/storage/emulated/0/Download/Articles/$filename';
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final dio = Dio();
    dio.interceptors.add(LogInterceptor());
    final response = await dio.get(
      url,
      onReceiveProgress: (received, total) =>
          showDownloadProgress(received, total, onProgressChange),
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: Duration(seconds: 5),
      ),
    );
    final file = await File(savePath).create(recursive: true);
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    onDownloadEnd();

}

void showDownloadProgress(received, total, Function(String) onProgressChanged) {
  if (total != -1) {
    onProgressChanged((received / total * 100).toStringAsFixed(0) + '%');
    debugPrint((received / total * 100).toStringAsFixed(0) + '%');
  }
}
