class NakshatraPada {
  final String nakshatraName;
  final int pada; // 1, 2, 3, or 4
  final double startLongitudeDeg;
  final double endLongitudeDeg;

  const NakshatraPada({
    required this.nakshatraName,
    required this.pada,
    required this.startLongitudeDeg,
    required this.endLongitudeDeg,
  });

  static const double padaArcDeg = 3.3333333333333335; // 3° 20' = 3.333°

  static NakshatraPada calculate(double moonLonDeg) {
    final normLon = (moonLonDeg % 360.0 + 360.0) % 360.0;
    final totalPadas = (normLon / padaArcDeg).floor();
    final nakshatraIndex = totalPadas ~/ 4;
    final pada = (totalPadas % 4) + 1;

    const nakshatras = [
      'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
      'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni',
      'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha',
      'Jyeshtha', 'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana',
      'Dhanishta', 'Shatabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'
    ];

    final name = nakshatras[nakshatraIndex % 27];
    final startDeg = totalPadas * padaArcDeg;
    return NakshatraPada(
      nakshatraName: name,
      pada: pada,
      startLongitudeDeg: startDeg,
      endLongitudeDeg: startDeg + padaArcDeg,
    );
  }
}
