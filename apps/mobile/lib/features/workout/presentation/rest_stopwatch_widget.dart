import 'dart:async';
import 'package:flutter/material.dart';

class RestStopwatchWidget extends StatefulWidget {
  final DateTime Function() now;

  const RestStopwatchWidget({
    super.key,
    this.now = DateTime.now,
  });

  @override
  State<RestStopwatchWidget> createState() => _RestStopwatchWidgetState();
}

class _RestStopwatchWidgetState extends State<RestStopwatchWidget> {
  DateTime? _startTime;
  Duration _previousDuration = Duration.zero;
  Timer? _timer;
  final ValueNotifier<Duration> _elapsedNotifier = ValueNotifier(Duration.zero);

  bool get _isRunning => _startTime != null;

  Duration get _elapsedDuration {
    if (_startTime == null) return _previousDuration;
    return _previousDuration + widget.now().difference(_startTime!);
  }

  void _start() {
    if (_isRunning) return;
    setState(() {
      _startTime = widget.now();
      _elapsedNotifier.value = _elapsedDuration;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedNotifier.value = _elapsedDuration;
      });
    });
  }

  void _pause() {
    if (!_isRunning) return;
    setState(() {
      _previousDuration += widget.now().difference(_startTime!);
      _startTime = null;
      _elapsedNotifier.value = _previousDuration;
      _timer?.cancel();
      _timer = null;
    });
  }

  void _reset() {
    setState(() {
      _startTime = null;
      _previousDuration = Duration.zero;
      _elapsedNotifier.value = Duration.zero;
      _timer?.cancel();
      _timer = null;
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _elapsedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 60,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.white70, size: 20),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 76,
                    child: ValueListenableBuilder<Duration>(
                      valueListenable: _elapsedNotifier,
                      builder: (context, elapsed, child) {
                        return Text(
                          _formatDuration(elapsed),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (!_isRunning)
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, size: 32),
                      color: theme.colorScheme.primary,
                      onPressed: _start,
                      tooltip: 'Start',
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.pause_rounded, size: 32),
                      color: theme.colorScheme.primary,
                      onPressed: _pause,
                      tooltip: 'Pause',
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 28),
                    color: Colors.white70,
                    onPressed: _reset,
                    tooltip: 'Reset',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
