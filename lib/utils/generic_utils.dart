import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/models/generic/photo_model.dart';
import 'package:permission_handler/permission_handler.dart';

class GenericUtils {
  // ========================================================================
  // Media
  // ========================================================================

  // Seleccion de imagen desde camara o galeria del dispositivo
  static Future<void> getImageFromDevice({
    required bool isFromCamera,
    required void Function(PhotoModel) onGetImage,
    List<String> allowedExtensions = const ["jpg", "jpeg", "png"],
  }) async {
    try {
      final source = (isFromCamera) ? ImageSource.camera : ImageSource.gallery;

      // Solicitando permisos
      await Permission.camera.status.then((cameraPermissionStatus) async {
        if (cameraPermissionStatus.isGranted) {
          // Tomando imagen con camara del dispositivo
          await ImagePicker().pickImage(source: source).then((pickedFile) {
            if (pickedFile != null) {
              final extension = pickedFile.path.split('.').last.toLowerCase();

              // Validando extension del archivo
              final allowedExtensionValues = allowedExtensions
                  .map((e) => e.toLowerCase())
                  .toList();

              if (allowedExtensionValues.contains(extension)) {
                final file = File(pickedFile.path);

                final photo = PhotoModel(
                  file: file,
                  name: pickedFile.name,
                  id: DateTime.now().toIso8601String(),
                );

                onGetImage(photo);
              } else {
                log("Ha ocurrido un error con la extension del archivo.");
              }
            } else {
              log("Ningún archivo ha sido seleccionado.");
            }
          });
        } else {
          await Permission.camera.request().then((cameraPermission) {
            if (cameraPermission.isDenied) {
            } else {
              getImageFromDevice(
                isFromCamera: isFromCamera,
                onGetImage: onGetImage,
              );
            }
          });
        }
      });
    } catch (e) {
      log("Ha ocurrido un error ${e.toString()}");
    }
  }

  // Seleccion de archivoo desde el dispositivo
  static Future<void> getFileFromDevice({
    required void Function(FileModel) onGetFiles,
    // List<String> allowedExtensions = const ["pdf"],
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      // allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      var documents = result.files.single.path!;

      final file = FileModel(
        id: DateTime.now().toIso8601String(),
        name: result.names.single ?? "unknown",
        file: File(documents),
      );

      onGetFiles(file);
    }
  }

  // ========================================================================
  // File
  // ========================================================================

  // static Future<void> _openFile(File file) async {
  //   try {
  //     await OpenFilex.open(file.path);
  //   } catch (e) {
  //     throw Exception('Error open filex: $e');
  //   }
  // }

  // Gets Download Path
  static Future<String> _findLocalPathDownloads() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      } else {
        final directory = (await getExternalStorageDirectory())!;
        return directory.path;
      }
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  static Future<void> downloadFile({
    required String url,
    required String fileName,
    void Function(int count, int total)? onReceiveProgress,
    void Function()? onAlreadyExists,
  }) async {
    try {
      //final permissions = await _checkStoragePermission();
      //if (!permissions) return;

      final String downloadsPath = await _findLocalPathDownloads();
      late String path;

      // Adding File Extension if needed
      // if (fileName.split('.').last == url.split('.').last) {
      //   path = '$downloadsPath${Platform.pathSeparator}$fileName';
      // } else {
      //   path =
      //       '$downloadsPath${Platform.pathSeparator}$fileName.${url.split('.').last}';
      // }

      path = '$downloadsPath${Platform.pathSeparator}$fileName';

      final file = File(path);

      // Checking if file already exists
      if (!(await file.exists())) {
        await Dio().download(url, path, onReceiveProgress: onReceiveProgress);
        //await _openFile(file);
      } else {
        //await _openFile(file);
        if (onAlreadyExists != null) onAlreadyExists();
      }
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }
}
