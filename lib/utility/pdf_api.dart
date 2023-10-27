import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class PDFApi {

  static File? _file;
  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;
    return File(result.paths!.first!);
  }

  static Future openFile(File? file) async {
    final url = file!.path;
    await OpenFile.open(url);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf
  }) async {
    final bytes = await  pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static   Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      try {
        final status = await Permission.storage.request();
        return status.isGranted;
      } on Exception catch (e) {
        print('permission error---------$e');
        return false;
      }
    } else{
      return false;
    }
  }

  static Future<void> downloadFileToStorage(File pdfFile) async {
    print('PDF path to: ${pdfFile.path}');
    // Get external storage directory
    final storageDirectory = await getExternalStorageDirectory();
    print('storageDirectory: ${storageDirectory?.path}');
    // Create the file path
    String filePath='';
    final isRealDevice =  !Platform.isAndroid && !Platform.isIOS;
    final isEmulator =  Platform.isAndroid || Platform.isIOS;
    if(!isEmulator){
      filePath = '${storageDirectory?.path}/${pdfFile.path.split('/').last}';
    }else{
      filePath = '/storage/emulated/0/Download/${pdfFile.path.split('/').last}';
    }
    print('PDF file saved to: $filePath');
    // Write the PDF file to the external storage
    final File file = File(filePath);
    //for a directory: await Directory(savePath).exists();
    if (await file.exists()) {
      print("File exists");
    } else {
      print("File don't exists");
    }
    await file.writeAsBytes(pdfFile.readAsBytesSync());
  }


  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    return _storeFile(path, bytes);
  }

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }


}