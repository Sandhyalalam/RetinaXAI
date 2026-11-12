import 'package:flutter/material.dart';

import 'screens/analyzing_screen.dart';
import 'screens/book_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/doctors_screen.dart';
import 'screens/explain_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/result_screen.dart';
import 'state.dart';
import 'theme.dart';
import 'widgets/ui.dart';

class RetinaXAIApp extends StatelessWidget {
  const RetinaXAIApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RetinaXAI',
      debugShowCheckedModeBanner: false,
      theme: RxTheme.data(),
      home: AnimatedBuilder(
        animation: state,
        builder: (context, _) => AppShell(state: state),
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final framed = width > 480;
    final body = ColoredBox(
      color: framed ? const Color(0xFFE8EEF5) : RxColors.bg,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Material(
            color: RxColors.bg,
            elevation: framed ? 8 : 0,
            borderRadius: framed ? BorderRadius.circular(36) : BorderRadius.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                const StatusBar(),
                Expanded(child: _page()),
                BottomNav(
                  index: state.tab.index,
                  onTap: (i) => state.setTab(AppTab.values[i]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Scaffold(backgroundColor: framed ? const Color(0xFFE8EEF5) : RxColors.bg, body: SafeArea(child: body));
  }

  Widget _page() {
    if (state.tab == AppTab.home) {
      switch (state.homeFlow) {
        case HomeFlow.upload:
          return HomeScreen(state: state);
        case HomeFlow.analyzing:
          return AnalyzingScreen(state: state);
        case HomeFlow.result:
          return ResultScreen(state: state);
        case HomeFlow.explain:
          return ExplainScreen(state: state);
      }
    }
    if (state.tab == AppTab.history) return HistoryScreen(state: state);
    if (state.tab == AppTab.chat) return ChatScreen(state: state);
    if (state.tab == AppTab.doctors) {
      if (state.booking != null) return BookScreen(state: state);
      return DoctorsScreen(state: state);
    }
    return ProfileScreen(state: state);
  }
}
