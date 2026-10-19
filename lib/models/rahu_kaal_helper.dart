class RahuKaalWindow {
  final DateTime startTime;
  final DateTime endTime;
  final int periodIndex; // 1 to 8

  const RahuKaalWindow({
    required this.startTime,
    required this.endTime,
    required this.periodIndex,
  });

  bool isCurrentlyActive([DateTime? now]) {
    final current = now ?? DateTime.now();
    return current.isAfter(startTime) && current.isBefore(endTime);
  }

  String get formattedRange {
    final sH = startTime.hour.toString().padLeft(2, '0');
    final sM = startTime.minute.toString().padLeft(2, '0');
    final eH = endTime.hour.toString().padLeft(2, '0');
    final eM = endTime.minute.toString().padLeft(2, '0');
    return '$sH:$sM - $eH:$eM';
  }
}

class RahuKaalHelper {
  // 1-based period of daytime (out of 8 parts) for each weekday
  static const Map<int, int> weekdayPeriod = {
    DateTime.monday: 2,
    DateTime.saturday: 3,
    DateTime.friday: 4,
    DateTime.wednesday: 5,
    DateTime.thursday: 6,
    DateTime.tuesday: 7,
    DateTime.sunday: 8,
  };

  static RahuKaalWindow calculate({
    required DateTime date,
    required DateTime sunrise,
    required DateTime sunset,
  }) {
    final period = weekdayPeriod[date.weekday] ?? 8;
    final totalDayDuration = sunset.difference(sunrise);
    final partMs = totalDayDuration.inMilliseconds ~/ 8;

    final start = sunrise.add(Duration(milliseconds: partMs * (period - 1)));
    final end = (period == 8)
        ? sunset
        : sunrise.add(Duration(milliseconds: partMs * period));

    return RahuKaalWindow(startTime: start, endTime: end, periodIndex: period);
  }
}
