import 'package:flutter/material.dart';
import 'dart:io';

class ImageGallery extends StatelessWidget {
  final List<File> images;
  final Function(File) onRemoveImage;
  final Function(File) onImageTap;

  ImageGallery({
    required this.images,
    required this.onRemoveImage,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: images
                  .map(
                    (image) => GestureDetector(
                      onTap: () => onImageTap(image),
                      child: Stack(
                        children: [
                          Image.file(
                            image,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () => onRemoveImage(image),
                              child: Container(
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : Container();
  }
}
