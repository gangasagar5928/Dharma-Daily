class AbhijitMuhurtaCalculator {
  static Map<String, dynamic> calculate({
    required DateTime sunrise,
    required DateTime sunset,
    required int weekday,
  }) {
    // Abhijit Muhurta is the 8th muhurta of the day (each muhurta = day_duration / 15)
    // Inauspicious on Wednesday (blocked by Rahu Kaal overlap)
    final totalMs = sunset.difference(sunrise).inMilliseconds;
    final muhurtaMs = totalMs ~/ 15;

    final start = sunrise.add(Duration(milliseconds: muhurtaMs * 7));
    final end = sunrise.add(Duration(milliseconds: muhurtaMs * 8));

    final isWednesday = weekday == DateTime.wednesday;
    return {
      'startTime':
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      'endTime':
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
      'isBlockedByWednesday': isWednesday,
      'isAuspicious': !isWednesday,
    };
  }
}
