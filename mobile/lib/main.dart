import 'package:flutter/material.dart';

import 'app.dart';
import 'state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RetinaXAIApp(state: AppState()));
}
