import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models.dart';

class ApiService {
  ApiService({this.baseUrl = defaultBaseUrl});

  static const defaultBaseUrl = 'http://127.0.0.1:8000';

  String baseUrl;

  Future<bool> health() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<ScanResult> predict({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final uri = Uri.parse('$baseUrl/predict');
    final req = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );
    final streamed = await req.send().timeout(const Duration(seconds: 60));
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw Exception('Predict failed (${streamed.statusCode}): $body');
    }
    final json = jsonDecode(body) as Map<String, dynamic>;
    final heatmapB64 = json['heatmap_base64'] as String?;
    final probs = (json['probabilities'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final level = json['level'] as int;
    return ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      level: level,
      label: json['label'] as String? ?? DrLevel.labels[level],
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: probs,
      originalBytes: bytes,
      heatmapBytes:
          heatmapB64 == null ? null : base64Decode(heatmapB64),
      fileName: fileName,
      createdAt: DateTime.now(),
      source: 'api',
    );
  }
}

ScanResult demoResultFor(Uint8List bytes, String fileName) {
  return ScanResult(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    level: 3,
    label: 'Severe DR',
    confidence: 0.824,
    probabilities: const [0.01, 0.03, 0.09, 0.82, 0.05],
    originalBytes: bytes,
    heatmapBytes: null,
    fileName: fileName,
    createdAt: DateTime.now(),
    source: 'demo',
  );
}
