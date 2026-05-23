import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout/features/workout/presentation/rest_stopwatch_widget.dart';

void main() {
  late DateTime fakeNow;
  DateTime now() => fakeNow;

  setUp(() {
    fakeNow = DateTime(2026, 1, 1, 12, 0, 0);
  });

  testWidgets('RestStopwatchWidget starts at 00:00', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: RestStopwatchWidget(now: now),
        ),
      ),
    ));
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('RestStopwatchWidget starts and increments', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: RestStopwatchWidget(now: now),
        ),
      ),
    ));
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump(); 
    
    fakeNow = fakeNow.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    
    expect(find.text('00:02'), findsOneWidget);
  });

  testWidgets('RestStopwatchWidget pauses and resumes', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: RestStopwatchWidget(now: now),
        ),
      ),
    ));
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();
    fakeNow = fakeNow.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:02'), findsOneWidget);
    
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    
    fakeNow = fakeNow.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:02'), findsOneWidget);
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();
    fakeNow = fakeNow.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:03'), findsOneWidget);
  });

  testWidgets('RestStopwatchWidget resets', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: RestStopwatchWidget(now: now),
        ),
      ),
    ));
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();
    fakeNow = fakeNow.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:02'), findsOneWidget);
    
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    expect(find.text('00:00'), findsOneWidget);
  });
}
