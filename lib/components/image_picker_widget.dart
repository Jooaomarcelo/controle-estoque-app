import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File) onImagePicked;
  final String? image;

  const ImagePickerWidget({
    required this.onImagePicked,
    required this.image,
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  File? _image;

  void _pickImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) return;

    setState(() {
      _image = File(pickedImage.path);
    });

    widget.onImagePicked(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: _image == null && widget.image == ''
              ? Image.asset(
                  'assets/images/default-dark.png',
                  width: 90,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.image!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: _pickImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              const SizedBox(width: 5),
              Text(
                'Adicionar imagem',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
