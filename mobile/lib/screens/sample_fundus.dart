import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../widgets/ui.dart';

Uint8List? _cache;

Uint8List sampleFundusPng() {
  if (_cache != null) return _cache!;
  throw StateError('Call ensureSampleFundus() first.');
}

Future<Uint8List> ensureSampleFundus() async {
  if (_cache != null) return _cache!;
  const size = 512.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));
  FundusPainter().paint(canvas, const Size(size, size));
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  _cache = bytes!.buffer.asUint8List();
  return _cache!;
}
