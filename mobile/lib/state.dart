import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'services/api_service.dart';

enum AppTab { home, history, chat, doctors, profile }

enum HomeFlow { upload, analyzing, result, explain }

class AppState extends ChangeNotifier {
  AppState() {
    _load();
  }

  final api = ApiService();

  AppTab tab = AppTab.home;
  HomeFlow homeFlow = HomeFlow.upload;
  int historyFilter = 0;
  ScanResult? current;
  Doctor? selectedDoctor;
  AppointmentDraft? booking;
  final List<ScanResult> history = [];
  final List<ChatMessage> messages = [];
  bool analyzing = false;
  int analyzeStep = 0;
  String analyzeLabel = 'Running EfficientNet model...';
  bool backendOnline = false;
  String userName = 'Sandhya';
  String apiUrl = ApiService.defaultBaseUrl;
  bool shareConsent = true;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('apiUrl') ?? ApiService.defaultBaseUrl;
    api.baseUrl = apiUrl;
    userName = prefs.getString('userName') ?? 'Sandhya';
    final raw = prefs.getStringList('history') ?? [];
    history
      ..clear()
      ..addAll(raw.map((e) => ScanResult.fromJson(jsonDecode(e))));
    backendOnline = await api.health();
    _seedChat();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiUrl', apiUrl);
    await prefs.setString('userName', userName);
    await prefs.setStringList(
      'history',
      history.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  void setTab(AppTab value) {
    tab = value;
    if (value == AppTab.home && homeFlow == HomeFlow.analyzing) {
      homeFlow = HomeFlow.upload;
    }
    notifyListeners();
  }

  void setHistoryFilter(int index) {
    historyFilter = index;
    notifyListeners();
  }

  Future<void> setApiUrl(String url) async {
    apiUrl = url.trim();
    api.baseUrl = apiUrl;
    backendOnline = await api.health();
    await _persist();
    notifyListeners();
  }

  Future<void> ping() async {
    backendOnline = await api.health();
    notifyListeners();
  }

  List<ScanResult> get filteredHistory {
    return history.where((s) {
      if (historyFilter == 0) return true;
      if (historyFilter == 1) return s.level <= 1;
      if (historyFilter == 2) return s.level == 2;
      return s.level >= 3;
    }).toList();
  }

  Future<void> startAnalysis(Uint8List bytes, String fileName) async {
    current = ScanResult(
      id: 'pending',
      level: 0,
      label: '',
      confidence: 0,
      probabilities: const [0, 0, 0, 0, 0],
      originalBytes: bytes,
      fileName: fileName,
      createdAt: DateTime.now(),
    );
    homeFlow = HomeFlow.analyzing;
    analyzing = true;
    analyzeStep = 0;
    analyzeLabel = 'Running EfficientNet model...';
    tab = AppTab.home;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));
    analyzeStep = 1;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    analyzeStep = 2;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    analyzeLabel = 'Generating heatmap';
    notifyListeners();

    ScanResult result;
    try {
      backendOnline = await api.health();
      if (backendOnline) {
        result = await api.predict(bytes: bytes, fileName: fileName);
      } else {
        result = demoResultFor(bytes, fileName);
      }
    } catch (_) {
      result = demoResultFor(bytes, fileName);
      backendOnline = false;
    }

    current = result;
    history.removeWhere((e) => e.id == result.id);
    history.insert(0, result);
    analyzing = false;
    analyzeStep = 3;
    homeFlow = HomeFlow.result;
    _seedChat();
    await _persist();
    notifyListeners();
  }

  void openResult(ScanResult result) {
    current = result;
    homeFlow = HomeFlow.result;
    tab = AppTab.home;
    _seedChat();
    notifyListeners();
  }

  void showExplain() {
    homeFlow = HomeFlow.explain;
    notifyListeners();
  }

  void backFromFlow() {
    if (homeFlow == HomeFlow.explain) {
      homeFlow = HomeFlow.result;
    } else {
      homeFlow = HomeFlow.upload;
      current = null;
    }
    notifyListeners();
  }

  void newScan() {
    current = null;
    homeFlow = HomeFlow.upload;
    tab = AppTab.home;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> deleteScan(String id) async {
    history.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  void openDoctors() {
    tab = AppTab.doctors;
    selectedDoctor = null;
    booking = null;
    notifyListeners();
  }

  void openChat() {
    tab = AppTab.chat;
    notifyListeners();
  }

  void beginBooking(Doctor doctor) {
    selectedDoctor = doctor;
    booking = AppointmentDraft(
      doctor: doctor,
      date: DateTime(2026, 11, 15),
    );
    notifyListeners();
  }

  void updateBooking(AppointmentDraft draft) {
    booking = draft;
    notifyListeners();
  }

  void closeBooking() {
    booking = null;
    notifyListeners();
  }

  void confirmBooking() {
    booking = null;
    selectedDoctor = null;
    tab = AppTab.doctors;
    notifyListeners();
  }

  void _seedChat() {
    final result = current;
    messages
      ..clear()
      ..add(
        ChatMessage(
          text:
              'Hi $userName 👋 I can explain your screening result in simple words. What would you like to know?',
          fromUser: false,
        ),
      );
    if (result != null && result.id != 'pending') {
      messages.add(
        ChatMessage(
          text: 'What does ${result.title} mean?',
          fromUser: true,
        ),
      );
      messages.add(
        ChatMessage(
          text:
              'Level ${result.level} means the model found retinal patterns that resemble ${result.label.toLowerCase()}. It is a screening result, not a diagnosis — an eye specialist should review it soon.',
          fromUser: false,
          cta: 'Find a doctor',
        ),
      );
    }
  }

  void sendChat(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    messages.add(ChatMessage(text: trimmed, fromUser: true));
    messages.add(ChatMessage(text: _reply(trimmed), fromUser: false));
    notifyListeners();
  }

  String _reply(String text) {
    final q = text.toLowerCase();
    final result = current;
    if (q.contains('heatmap') || q.contains('grad')) {
      return 'The red/yellow areas are the regions that influenced the model most. It shows where the AI looked, not a confirmed lesion.';
    }
    if (q.contains('probab')) {
      if (result == null) {
        return 'After a scan, class probabilities show how likely each DR level is according to EfficientNet.';
      }
      final parts = <String>[];
      for (var i = 0; i < result.probabilities.length; i++) {
        parts.add(
          '${DrLevel.short[i]} ${(result.probabilities[i] * 100).round()}%',
        );
      }
      return 'The model distributed confidence as: ${parts.join(', ')}. The highest bar is the predicted class.';
    }
    if (q.contains('next') || q.contains('doctor') || q.contains('refer')) {
      return 'This is screening support only. For Level 2 or higher, book a retina specialist review and share the Grad-CAM report with consent.';
    }
    if (q.contains('diet') || q.contains('care') || q.contains('tip')) {
      return 'General care tips: keep blood sugar in the target range your clinician set, do not skip eye exams, and avoid smoking. These tips are educational, not a prescription.';
    }
    if (result != null) {
      return '${result.title} was predicted at ${(result.confidence * 100).toStringAsFixed(1)}% confidence. Ask about the heatmap, probabilities, or next steps.';
    }
    return 'Upload a fundus image on Home to generate a screening result. I can then explain the level, probabilities, and Grad-CAM heatmap.';
  }
}
