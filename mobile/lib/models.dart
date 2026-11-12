import 'dart:convert';
import 'dart:typed_data';

class DrLevel {
  static const labels = [
    'No DR',
    'Mild DR',
    'Moderate DR',
    'Severe DR',
    'Proliferative DR',
  ];

  static const short = ['No DR', 'Mild', 'Moderate', 'Severe', 'Prolif.'];

  static String title(int level) => 'Level $level – ${labels[level]}';
}

class ScanResult {
  ScanResult({
    required this.id,
    required this.level,
    required this.label,
    required this.confidence,
    required this.probabilities,
    required this.originalBytes,
    this.heatmapBytes,
    required this.fileName,
    required this.createdAt,
    this.source = 'demo',
  });

  final String id;
  final int level;
  final String label;
  final double confidence;
  final List<double> probabilities;
  final Uint8List originalBytes;
  final Uint8List? heatmapBytes;
  final String fileName;
  final DateTime createdAt;
  final String source;

  String get title => DrLevel.title(level);

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'label': label,
        'confidence': confidence,
        'probabilities': probabilities,
        'original': base64Encode(originalBytes),
        'heatmap': heatmapBytes == null ? null : base64Encode(heatmapBytes!),
        'fileName': fileName,
        'createdAt': createdAt.toIso8601String(),
        'source': source,
      };

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] as String,
      level: json['level'] as int,
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: (json['probabilities'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      originalBytes: base64Decode(json['original'] as String),
      heatmapBytes: json['heatmap'] == null
          ? null
          : base64Decode(json['heatmap'] as String),
      fileName: json['fileName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      source: json['source'] as String? ?? 'demo',
    );
  }
}

class Doctor {
  const Doctor({
    required this.name,
    required this.role,
    required this.years,
    required this.hospital,
    required this.distanceKm,
    required this.rating,
    required this.video,
    required this.inClinic,
  });

  final String name;
  final String role;
  final int years;
  final String hospital;
  final double distanceKm;
  final double rating;
  final bool video;
  final bool inClinic;
}

class ChatMessage {
  const ChatMessage({required this.text, required this.fromUser, this.cta});

  final String text;
  final bool fromUser;
  final String? cta;
}

class AppointmentDraft {
  AppointmentDraft({
    required this.doctor,
    this.video = true,
    required this.date,
    this.slot = '10:30',
    this.shareReport = true,
  });

  Doctor doctor;
  bool video;
  DateTime date;
  String slot;
  bool shareReport;
}

const sampleDoctors = [
  Doctor(
    name: 'Dr. Ananya Rao',
    role: 'Retina Specialist',
    years: 12,
    hospital: 'Sample Eye Hospital',
    distanceKm: 2.3,
    rating: 4.8,
    video: true,
    inClinic: true,
  ),
  Doctor(
    name: 'Dr. Vikram Mehta',
    role: 'Ophthalmologist',
    years: 9,
    hospital: 'Demo Vision Clinic',
    distanceKm: 4.1,
    rating: 4.6,
    video: true,
    inClinic: false,
  ),
  Doctor(
    name: 'Dr. Meera Iyer',
    role: 'Diabetic Eye Care',
    years: 15,
    hospital: 'Sample Care Centre',
    distanceKm: 6.8,
    rating: 4.7,
    video: true,
    inClinic: true,
  ),
];
