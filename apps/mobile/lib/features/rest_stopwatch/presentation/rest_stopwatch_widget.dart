import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/rest_stopwatch/application/rest_stopwatch_service.dart';

class RestStopwatchWidget extends StatefulWidget {
  const RestStopwatchWidget({super.key});

  @override
  State<RestStopwatchWidget> createState() => _RestStopwatchWidgetState();
}

class _RestStopwatchWidgetState extends State<RestStopwatchWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<RestStopwatchService>().reloadState();
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stopwatchService = Provider.of<RestStopwatchService>(context);

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
                    child: Text(
                      _formatDuration(stopwatchService.elapsedDuration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (!stopwatchService.isRunning)
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, size: 32),
                      color: theme.colorScheme.primary,
                      onPressed: stopwatchService.start,
                      tooltip: 'Start',
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.pause_rounded, size: 32),
                      color: theme.colorScheme.primary,
                      onPressed: stopwatchService.pause,
                      tooltip: 'Pause',
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 28),
                    color: Colors.white70,
                    onPressed: stopwatchService.reset,
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

