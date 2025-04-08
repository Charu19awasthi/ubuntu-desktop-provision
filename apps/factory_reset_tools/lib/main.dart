import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:factory_reset_tools/reset_tools_wizard.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyAccessibleApp());
}

class MyAccessibleApp extends StatefulWidget {
  const MyAccessibleApp({Key? key}) : super(key: key);

  @override
  State<MyAccessibleApp> createState() => _MyAccessibleAppState();
}

class _MyAccessibleAppState extends State<MyAccessibleApp> {
  bool _useHighContrast = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.speak("Welcome to the Factory Reset Wizard. Use tab key to navigate.");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factory Reset Tools',
      theme: _useHighContrast ? ThemeData.highContrast() : ThemeData.light(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Factory Reset Tools'),
          actions: [
            Switch(
              value: _useHighContrast,
              onChanged: (value) {
                setState(() {
                  _useHighContrast = value;
                  _tts.speak("High contrast mode ${value ? "enabled" : "disabled"}");
                });
              },
              tooltip: 'Toggle High Contrast Theme',
            )
          ],
        ),
        body: FocusTraversalGroup(
          child: Semantics(
            label: 'Reset Tools Wizard Main Screen',
            child: const ResetToolsWizard(),
          ),
        ),
      ),
    );
  }
}
