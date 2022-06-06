import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:provider/provider.dart';

class AddPostForm extends StatefulWidget {
  final void Function(int) navigateTo;

  const AddPostForm(this.navigateTo, {Key? key}) : super(key: key);

  @override
  State<AddPostForm> createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  bool _isLoading = false;
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

  void trySubmit() async {
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState?.save();
    final isValid = _formKey.currentState?.validate();

    if (_pickedImage == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (isValid == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      if (isValid) {
        await Provider.of<Posts>(context, listen: false)
            .addData(_caption!, _pickedImage!);

        setState(() {
          _caption = null;
          _pickedImage = null;
          _isLoading = false;
        });

        // Change tabs to home
        widget.navigateTo(0);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
            decoration: const InputDecoration(hintText: 'Write a caption'),
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
                  child: const Center(
                    child: Text('Please add image'),
                  ),
                ),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: trySubmit, child: const Text('Add Post'))
        ],
      ),
    );
  }
}
