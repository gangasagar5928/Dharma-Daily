enum ChoghadiyaType { amrit, shubh, labh, char, rog, kaal, udveg }

enum ChoghadiyaNature { auspicious, neutral, inauspicious }

class ChoghadiyaPeriod {
  final ChoghadiyaType type;
  final String name;
  final String rulingPlanet;
  final ChoghadiyaNature nature;
  final String startTime;
  final String endTime;
  final bool isDaytime;

  const ChoghadiyaPeriod({
    required this.type,
    required this.name,
    required this.rulingPlanet,
    required this.nature,
    required this.startTime,
    required this.endTime,
    required this.isDaytime,
  });

  bool get isGoodForTravel =>
      type == ChoghadiyaType.char ||
      type == ChoghadiyaType.labh ||
      type == ChoghadiyaType.amrit ||
      type == ChoghadiyaType.shubh;

  bool get isAuspicious => nature == ChoghadiyaNature.auspicious;
}

class ChoghadiyaCalculator {
  static const Map<ChoghadiyaType, Map<String, dynamic>> _metadata = {
    ChoghadiyaType.amrit: {
      'name': 'Amrita',
      'planet': 'Moon',
      'nature': ChoghadiyaNature.auspicious,
    },
    ChoghadiyaType.shubh: {
      'name': 'Shubha',
      'planet': 'Jupiter',
      'nature': ChoghadiyaNature.auspicious,
    },
    ChoghadiyaType.labh: {
      'name': 'Labha',
      'planet': 'Mercury',
      'nature': ChoghadiyaNature.auspicious,
    },
    ChoghadiyaType.char: {
      'name': 'Chala',
      'planet': 'Venus',
      'nature': ChoghadiyaNature.neutral,
    },
    ChoghadiyaType.rog: {
      'name': 'Roga',
      'planet': 'Mars',
      'nature': ChoghadiyaNature.inauspicious,
    },
    ChoghadiyaType.kaal: {
      'name': 'Kala',
      'planet': 'Saturn',
      'nature': ChoghadiyaNature.inauspicious,
    },
    ChoghadiyaType.udveg: {
      'name': 'Udvega',
      'planet': 'Sun',
      'nature': ChoghadiyaNature.inauspicious,
    },
  };

  static const Map<int, List<ChoghadiyaType>> daySequence = {
    DateTime.sunday: [
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
    ],
    DateTime.monday: [
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
    ],
    DateTime.tuesday: [
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
    ],
    DateTime.wednesday: [
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
    ],
    DateTime.thursday: [
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
    ],
    DateTime.friday: [
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
    ],
    DateTime.saturday: [
      ChoghadiyaType.kaal,
      ChoghadiyaType.shubh,
      ChoghadiyaType.rog,
      ChoghadiyaType.udveg,
      ChoghadiyaType.char,
      ChoghadiyaType.labh,
      ChoghadiyaType.amrit,
      ChoghadiyaType.kaal,
    ],
  };

  static List<ChoghadiyaPeriod> calculateDayChoghadiya({
    required DateTime date,
    required DateTime sunrise,
    required DateTime sunset,
  }) {
    final types = daySequence[date.weekday] ?? daySequence[DateTime.sunday]!;
    final totalDuration = sunset.difference(sunrise);
    final partDuration = Duration(
      milliseconds: totalDuration.inMilliseconds ~/ 8,
    );

    final periods = <ChoghadiyaPeriod>[];
    for (int i = 0; i < 8; i++) {
      final start = sunrise.add(partDuration * i);
      final end = (i == 7) ? sunset : sunrise.add(partDuration * (i + 1));
      final type = types[i];
      final meta = _metadata[type]!;

      periods.add(
        ChoghadiyaPeriod(
          type: type,
          name: meta['name'] as String,
          rulingPlanet: meta['planet'] as String,
          nature: meta['nature'] as ChoghadiyaNature,
          startTime: _formatTime(start),
          endTime: _formatTime(end),
          isDaytime: true,
        ),
      );
    }
    return periods;
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
