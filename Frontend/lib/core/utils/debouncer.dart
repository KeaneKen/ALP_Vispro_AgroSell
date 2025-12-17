import 'dart:async';

/// A simple debouncer that allows grouping rapid calls keyed by an identifier.
///
/// Usage:
/// ```dart
/// final debouncer = Debouncer();
/// debouncer.run('item-123', Duration(milliseconds: 300), () { ... });
/// ```
class Debouncer {
  final Map<String, Timer> _timers = {};

  /// Schedule [action] to run after [duration]. If another call with the
  /// same [key] happens before the timer fires, the previous timer is
  /// cancelled and a new one is scheduled.
  void run(String key, Duration duration, VoidCallback action) {
    _timers[key]?.cancel();
    _timers[key] = Timer(duration, () {
      _timers.remove(key);
      try {
        action();
      } catch (_) {}
    });
  }

  /// Cancel a pending action for [key], if any.
  void cancel(String key) {
    _timers.remove(key)?.cancel();
  }

  /// Cancel all pending actions.
  void cancelAll() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }
}
