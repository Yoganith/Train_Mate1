/// Small helpers to safely parse numbers/currency-like strings used across the app.
/// These helpers strip non-numeric characters (except dot and minus for doubles)
/// and use tryParse with a sensible fallback to avoid throwing FormatException.
int safeParseInt(Object? value, {int fallback = 0}) {
  if (value == null) return fallback;
  final s = value.toString();
  final cleaned = s.replaceAll(RegExp(r"[^0-9\-]"), '');
  return int.tryParse(cleaned) ?? fallback;
}

double safeParseDouble(Object? value, {double fallback = 0.0}) {
  if (value == null) return fallback;
  final s = value.toString();
  // keep digits, dot and minus
  final cleaned = s.replaceAll(RegExp(r"[^0-9\.\-]"), '');
  return double.tryParse(cleaned) ?? fallback;
}
