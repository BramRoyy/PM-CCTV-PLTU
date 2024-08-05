import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:quickalert/quickalert.dart';
import 'package:mime/mime.dart';

class FileManager extends StatelessWidget {
  final Function(File) onImageSelected;

  FileManager({required this.onImageSelected});

  void _openFileExplorer(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      allowedExtensions: null,
    );

    if (result != null) {
      bool allImages = true;
      for (var path in result.paths) {
        if (path != null) {
          final mimeType = lookupMimeType(path);
          if (mimeType != null && mimeType.startsWith('image/')) {
            onImageSelected(File(path));
          } else {
            allImages = false;
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: 'Berkas Yang Anda Pilih Tidak Berformat Gambar',
            );
            break;
          }
        }
      }
      if (allImages) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: '${result.paths.length} file(s) selected',
        );
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'File selection canceled',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openFileExplorer(context),
      child: Text('Pilih Foto'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.white,
      ),
    );
  }
}
