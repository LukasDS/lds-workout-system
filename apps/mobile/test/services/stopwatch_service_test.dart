import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/features/workout/presentation/stopwatch_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StopwatchService', () {
    late SharedPreferences prefs;
    late StopwatchService service;
    final List<MethodCall> methodCalls = [];

    setUp(() async {
      methodCalls.clear();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('io.github.lukasds.workout/stopwatch'),
        (methodCall) async {
          methodCalls.add(methodCall);
          return null;
        },
      );

      service = StopwatchService(prefs);
    });

    tearDown(() {
      service.dispose();
    });

    test('Initial state is stopped', () {
      expect(service.isRunning, isFalse);
      expect(service.elapsedDuration, Duration.zero);
    });

    test('start() starts the stopwatch', () {
      service.start();
      expect(service.isRunning, isTrue);
      expect(methodCalls.any((call) => call.method == 'startTimer'), isTrue);
    });

    test('pause() pauses the stopwatch', () async {
      service.start();
      final startElapsed = service.elapsedDuration;
      
      // Wait a bit
      await Future.delayed(const Duration(milliseconds: 100));
      
      service.pause();
      expect(service.isRunning, isFalse);
      final pausedElapsed = service.elapsedDuration;
      expect(pausedElapsed, greaterThan(startElapsed));
      
      // Wait more
      await Future.delayed(const Duration(milliseconds: 100));
      expect(service.elapsedDuration, pausedElapsed); // Should not change
      expect(methodCalls.any((call) => call.method == 'pauseTimer'), isTrue);
    });

    test('reset() resets duration but keeps running if it was running', () {
      service.start();
      service.reset();
      expect(service.isRunning, isTrue);
      expect(service.elapsedDuration.inSeconds, 0);
    });

    test('stop() stops and resets', () {
      service.start();
      service.stop();
      expect(service.isRunning, isFalse);
      expect(service.elapsedDuration, Duration.zero);
      expect(methodCalls.any((call) => call.method == 'stopTimer'), isTrue);
    });

    test('State is persisted and loaded', () async {
      service.start();
      // Allow async _saveState() to complete
      await Future.delayed(Duration.zero);
      
      final startTime = prefs.getInt('stopwatch_start_time');
      expect(startTime, isNotNull);
      expect(prefs.getBool('stopwatch_is_running'), isTrue);
// Create a new service instance to simulate app restart
final newService = StopwatchService(prefs);
expect(newService.isRunning, isTrue);
expect(newService.elapsedDuration.inMilliseconds, greaterThan(0));
newService.dispose();
});

test('reloads state when receiving native reloadState call', () async {
  await prefs.setInt('stopwatch_previous_duration', 10000);

  // Simulate native call
  final ByteData? message = const StandardMethodCodec().encodeMethodCall(
    const MethodCall('reloadState'),
  );
await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    .handlePlatformMessage(
  'io.github.lukasds.workout/stopwatch',
  message,
  (data) {},
);

expect(service.elapsedDuration.inSeconds, 10);
});

test('gracefully handles PlatformException on native calls', () async {
TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    .setMockMethodCallHandler(
  const MethodChannel('io.github.lukasds.workout/stopwatch'),
  (methodCall) async {
    throw PlatformException(code: 'ERROR', message: 'Native error');
  },
);

// Should not throw
service.start();
expect(service.isRunning, isTrue);
});
});
}
