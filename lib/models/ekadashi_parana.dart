class EkadashiParanaWindow {
  final DateTime paranaStart;
  final DateTime paranaEnd;
  final String fastingDayName;

  const EkadashiParanaWindow({
    required this.paranaStart,
    required this.paranaEnd,
    required this.fastingDayName,
  });

  String get formattedRange {
    final sH = paranaStart.hour.toString().padLeft(2, '0');
    final sM = paranaStart.minute.toString().padLeft(2, '0');
    final eH = paranaEnd.hour.toString().padLeft(2, '0');
    final eM = paranaEnd.minute.toString().padLeft(2, '0');
    return '$sH:$sM - $eH:$eM';
  }
}
