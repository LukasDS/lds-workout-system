import 'dart:async';

/// A utility class for debouncing actions, preventing them from being called too frequently.
/// It allows you to specify a delay in milliseconds, and if the action is called again before
/// the delay expires, the previous call is canceled and the timer is reset.
///
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  /// Runs the provided action after the specified milliseconds, resetting the timer if called again.
  /// If the timer is already running, it cancels the previous timer and starts a new one.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels the current timer if it is running.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}