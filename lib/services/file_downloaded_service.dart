import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class FileDownloadedService {
  static Future<String> getDownloadsPath() async {
    final dir = await getExternalStorageDirectory();
    if (dir == null) throw Exception("Could not access storage");

    final downloadsDir = Directory("${dir.path}/Downloads");
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir.path;
  }

  static Future<void> saveFile(String sourcePath, String fileName) async {
    try {
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      if (Platform.isAndroid && (await Permission.storage.isDenied)) {
        await Permission.storage.request();
      }

      String downloadsPath = await getDownloadsPath();
      String filePath = "$downloadsPath/$fileName";
      File file = File(filePath);

      if (sourcePath.startsWith("http")) {
        Dio dio = Dio();
        await dio.download(
          sourcePath,
          filePath,
          onReceiveProgress: (count, total) {
            final percent = (count / total * 100).toStringAsFixed(0);
            debugPrint("Downloading: $percent%");
          },
        );
      } else if (sourcePath.startsWith("assets/")) {
        ByteData data = await rootBundle.load(sourcePath);
        await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      } else {
        throw Exception("Invalid source path: $sourcePath");
      }

      debugPrint("✅ File saved successfully at: $filePath");

      await _showDownloadNotification(fileName, filePath);
    } catch (e) {
      debugPrint("❌ Save error: $e");
      rethrow;
    }
  }

  static Future<void> _showDownloadNotification(
    String fileName,
    String filePath,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'download_channel',
          'Downloads',
          channelDescription: 'File download notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download complete',
      '$fileName saved',
      platformDetails,
      payload: filePath,
    );
  }
}
