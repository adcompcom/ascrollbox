import 'package:flutter/widgets.dart';

// Guards against double taps firing the same action twice.

final Set<Object> _running = {};

/// Runs [action] unless a previous call with the same [key] is still running.
/// Returns null when the call was skipped.
Future<T?> runOnce<T>(Object key, Future<T> Function() action) async {
  if (!_running.add(key)) return null;
  try {
    return await action();
  } finally {
    _running.remove(key);
  }
}

/// Whether [context]'s route is the top-most one. Right after a push or pop
/// it no longer is, even before the transition has painted.
bool isTopRoute(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent ?? true;

/// Pushes [route] only if [context] is on the top route, so a double tap
/// can't open the same screen twice.
Future<T?> pushOnce<T>(BuildContext context, Route<T> route) {
  if (!isTopRoute(context)) return Future.value(null);
  return Navigator.push(context, route);
}

/// Pops only if [context]'s route is still on top, so a double tap on a
/// dialog or sheet button can't also close the screen behind it.
/// [context] must belong to the route being closed (e.g. a dialog's builder
/// context). Returns whether it popped.
bool popOnce<T>(BuildContext context, [T? result]) {
  if (!isTopRoute(context)) return false;
  Navigator.pop(context, result);
  return true;
}
