import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({Key? key}) : super(key: key);

  @override
  State<AddPostForm> createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  File? _pickedImage;
  String? _caption;
  final _formKey = GlobalKey<FormState>();

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
  }

  void trySubmit() {
    final isValid = _formKey.currentState?.validate();
    _formKey.currentState?.save();

    if (_pickedImage == null) {
      return;
    }

    if (isValid == null) {
      return;
    }

    if (isValid) {
      print('Valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Add post form');
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Write a caption'),
              validator: (value) {
                if (value == null) {
                  return 'Input is null';
                }
                if (value.isEmpty) {
                  return 'Caption can not be empty';
                }
                if (value.length < 3) {
                  return 'Caption must be at least 4 characters';
                }
                return null;
              },
              onSaved: (value) {
                _caption = value;
              },
            ),
            _pickedImage != null
                ? InkWell(
                    child: Image(image: FileImage(_pickedImage!)),
                    onTap: _pickImage,
                  )
                : InkWell(
                    onTap: _pickImage,
                    child: Center(
                      child: Text('Please add image'),
                    ),
                  ),
            ElevatedButton(onPressed: trySubmit, child: Text('Add Post'))
          ],
        ));
  }
}
