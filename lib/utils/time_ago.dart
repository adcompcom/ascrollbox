import '../l10n/generated/app_localizations.dart';

/// Short relative time for [date], e.g. "hace 3 min", "hace 2 días".
String timeAgo(AppLocalizations l10n, DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);
  // Clock skew can put a just-saved video slightly in the future.
  if (diff.inMinutes < 1) return l10n.timeJustNow;
  if (diff.inHours < 1) return l10n.timeMinutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return l10n.timeHoursAgo(diff.inHours);
  if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
  if (diff.inDays < 30) return l10n.timeWeeksAgo(diff.inDays ~/ 7);
  if (diff.inDays < 365) return l10n.timeMonthsAgo(diff.inDays ~/ 30);
  return l10n.timeYearsAgo(diff.inDays ~/ 365);
}
