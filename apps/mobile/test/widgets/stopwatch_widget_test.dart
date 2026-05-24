import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/features/workout/presentation/rest_stopwatch_widget.dart';
import 'package:workout/features/workout/presentation/stopwatch_service.dart';

void main() {
  late SharedPreferences prefs;
  late StopwatchService stopwatchService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    stopwatchService = StopwatchService(prefs);

    // Mock MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('io.github.lukasds.workout/stopwatch'),
      (methodCall) async => null,
    );
  });

  tearDown(() {
    stopwatchService.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('io.github.lukasds.workout/stopwatch'),
      null,
    );
  });

  testWidgets('RestStopwatchWidget starts at 00:00', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<StopwatchService>.value(
            value: stopwatchService,
            child: const RestStopwatchWidget(),
          ),
        ),
      ),
    );
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('RestStopwatchWidget starts and increments', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<StopwatchService>.value(
            value: stopwatchService,
            child: const RestStopwatchWidget(),
          ),
        ),
      ),
    );
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pumpAndSettle(); 
    
    expect(stopwatchService.isRunning, isTrue);
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    
    // Cleanup
    stopwatchService.stop();
    await tester.pumpAndSettle();
  });

  testWidgets('RestStopwatchWidget resets but keeps running', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<StopwatchService>.value(
            value: stopwatchService,
            child: const RestStopwatchWidget(),
          ),
        ),
      ),
    );
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pumpAndSettle();
    expect(stopwatchService.isRunning, isTrue);
    
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pumpAndSettle();
    
    // NEW BEHAVIOR: Should still be running
    expect(stopwatchService.isRunning, isTrue);
    
    // Cleanup
    stopwatchService.stop();
    await tester.pumpAndSettle();
  });
}
