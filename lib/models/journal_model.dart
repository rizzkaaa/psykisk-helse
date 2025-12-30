import 'dart:io';

import 'package:flutter/material.dart';

class DocBlock {
  String type;
  TextEditingController? controller;
  File? imageFile;
  double widthFactor;

  DocBlock({
    required this.type,
    this.controller,
    this.imageFile,
    this.widthFactor = 1.0,
  });

  DocBlock copy() => DocBlock(
    type: type,
    controller: controller != null
        ? TextEditingController(text: controller!.text)
        : null,
    imageFile: imageFile,
    widthFactor: widthFactor,
  );
}
