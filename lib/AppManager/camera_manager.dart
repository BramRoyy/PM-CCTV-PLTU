import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:quickalert/quickalert.dart';

class CameraManager extends StatelessWidget {
  final bool multiCapture;
  final Function(File) onImageCaptured;

  CameraManager({required this.multiCapture, required this.onImageCaptured});

  Future<void> _openCamera(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();

    if (multiCapture) {
      bool continueCapturing = true;
      while (continueCapturing) {
        XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

        if (image != null) {
          onImageCaptured(File(image.path));
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Picture taken: ${image.path}',
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: 'Tidak Ada Gambar Yang Diambil',
          );
          continueCapturing = false;
        }
      }
    } else {
      XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

      if (image != null) {
        onImageCaptured(File(image.path));
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Gambar Berhasil Ditambahkan',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Tidak Ada Gambar Yang Diambil',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openCamera(context),
      child: Icon(Icons.camera_alt),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
    );
  }
}
