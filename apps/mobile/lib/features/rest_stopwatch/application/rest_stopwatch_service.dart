import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestStopwatchService extends ChangeNotifier {
  static const String _keyStartTime = 'stopwatch_start_time';
  static const String _keyPreviousDuration = 'stopwatch_previous_duration';
  static const String _keyIsRunning = 'stopwatch_is_running';

  static const _channel = MethodChannel('io.github.lukasds.workout/stopwatch');

  final SharedPreferences _prefs;

  DateTime? _startTime;
  Duration _previousDuration = Duration.zero;
  bool _isRunning = false;
  Timer? _timer;

  RestStopwatchService(this._prefs) {
    _loadState();
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'reloadState') {
        await reloadState();
      }
    });
  }

  bool get isRunning => _isRunning;

  Duration get elapsedDuration {
    if (!_isRunning || _startTime == null) return _previousDuration;
    return _previousDuration + DateTime.now().difference(_startTime!);
  }

  Future<void> reloadState() async {
    // FORCE Flutter to read the native changes from the disk file
    await _prefs.reload();
    _loadState(updateNative: false); // Skip update back to native as native just told us to reload
    notifyListeners();
  }

  void _loadState({bool updateNative = true}) {
    final startTimeMillis = _prefs.getInt(_keyStartTime);
    if (startTimeMillis != null) {
      _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
    } else {
      _startTime = null;
    }
    _previousDuration = Duration(milliseconds: _prefs.getInt(_keyPreviousDuration) ?? 0);
    _isRunning = _prefs.getBool(_keyIsRunning) ?? false;

    if (_isRunning) {
      _startTimer();
      if (updateNative) _updateNativeNotification();
    } else {
      _timer?.cancel();
      _timer = null;
      // If there's an active (but paused) timer, ensure the notification is shown
      if (_previousDuration > Duration.zero) {
        if (updateNative) _updateNativeNotification();
      }
    }
  }

  Future<void> _saveState() async {
    if (_startTime != null) {
      await _prefs.setInt(_keyStartTime, _startTime!.millisecondsSinceEpoch);
    } else {
      await _prefs.remove(_keyStartTime);
    }
    await _prefs.setInt(_keyPreviousDuration, _previousDuration.inMilliseconds);
    await _prefs.setBool(_keyIsRunning, _isRunning);
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _startTime = DateTime.now();
    _startTimer();
    _saveState();
    _updateNativeNotification();
    notifyListeners();
  }

  void pause() {
    if (!_isRunning) return;
    _previousDuration += DateTime.now().difference(_startTime!);
    _startTime = null;
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _saveState();
    _updateNativeNotification();
    notifyListeners();
  }

  void reset() {
    // Reset behavior: keeps running if it was running, resets time to zero
    _previousDuration = Duration.zero;
    if (_isRunning) {
      _startTime = DateTime.now();
    } else {
      _startTime = null;
    }
    _saveState();
    // Use forceShow: true to ensure the notification stays visible even at zero time
    _updateNativeNotification(forceShow: true);
    notifyListeners();
  }

  void stop() {
    _isRunning = false;
    _startTime = null;
    _previousDuration = Duration.zero;
    _timer?.cancel();
    _timer = null;
    _saveState();
    _updateNativeNotification(close: true);
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  Future<void> _updateNativeNotification({bool close = false, bool forceShow = false}) async {
    try {
      if (close) {
        await _channel.invokeMethod('stopTimer');
        return;
      }

      if (_isRunning) {
        await _channel.invokeMethod('startTimer', {
          'startTime': _startTime!.millisecondsSinceEpoch,
          'previousDuration': _previousDuration.inMilliseconds,
        });
      } else if (_previousDuration > Duration.zero || forceShow) {
        await _channel.invokeMethod('pauseTimer', {
          'previousDuration': _previousDuration.inMilliseconds,
        });
      } else {
        await _channel.invokeMethod('stopTimer');
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to update native notification: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
