class BrahmaMuhurtaCalculator {
  // Brahma Muhurta begins 2 muhurtas (96 minutes) prior to sunrise and lasts 48 minutes
  static Map<String, dynamic> calculate(DateTime sunrise) {
    final start = sunrise.subtract(const Duration(minutes: 96));
    final end = sunrise.subtract(const Duration(minutes: 48));
    return {
      'startTime':
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      'endTime':
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
      'durationMinutes': 48,
    };
  }
}
