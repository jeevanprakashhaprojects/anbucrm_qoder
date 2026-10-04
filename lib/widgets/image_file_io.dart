import 'dart:io';
import 'package:flutter/material.dart';

/// Native implementation: loads image from local file path using dart:io.
Widget buildFileImage(
  String path, {
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  String? semanticLabel,
}) {
  return Image.file(
    File(path),
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    color: color,
    semanticLabel: semanticLabel,
  );
}
