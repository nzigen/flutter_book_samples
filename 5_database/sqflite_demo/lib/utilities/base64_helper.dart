import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Base64Helper {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
