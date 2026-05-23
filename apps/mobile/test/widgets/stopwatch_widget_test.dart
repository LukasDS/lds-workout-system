import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout/features/workout/presentation/stopwatch_widget.dart';

void main() {
  late DateTime fakeNow;
  DateTime now() => fakeNow;

  setUp(() {
    fakeNow = DateTime(2026, 1, 1, 12, 0, 0);
  });

  testWidgets('StopwatchWidget starts at 00:00', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: StopwatchWidget(now: now),
        ),
      ),
    ));
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('StopwatchWidget starts and increments', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: StopwatchWidget(now: now),
        ),
      ),
    ));
    
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump(); 
    
    fakeNow = fakeNow.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    
    expect(find.text('00:02'), findsOneWidget);
  });

  testWidgets('StopwatchWidget pauses and resumes', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: StopwatchWidget(now: now),
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

  testWidgets('StopwatchWidget resets', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: StopwatchWidget(now: now),
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
