
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

class CustomImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    if (key.startsWith('asset://')) {
      final asset = AssetImage(key.replaceFirst('asset://', ''));
      return Image(image: asset);
    } else {
      final file = File.fromUri(Uri.parse(key));
      final image = FileImage(file);
      return Image(image: image);
    }
  }
}