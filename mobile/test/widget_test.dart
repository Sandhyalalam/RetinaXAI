import 'package:flutter_test/flutter_test.dart';
import 'package:retinaxai/app.dart';
import 'package:retinaxai/state.dart';

void main() {
  testWidgets('Home screen shows RetinaXAI branding', (tester) async {
    await tester.pumpWidget(RetinaXAIApp(state: AppState()));
    expect(find.text('RetinaXAI'), findsWidgets);
    expect(find.text('Choose from Gallery'), findsOneWidget);
  });
}
