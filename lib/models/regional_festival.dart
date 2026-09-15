enum IndianRegion {
  panIndia,
  northIndia,
  southIndia,
  eastIndia,
  westIndia,
}

class RegionalFestivalFilter {
  static List<String> getRegionFestivals(IndianRegion region) {
    switch (region) {
      case IndianRegion.northIndia:
        return ['Karwa Chauth', 'Lohri', 'Bhai Dooj', 'Holi'];
      case IndianRegion.southIndia:
        return ['Pongal', 'Onam', 'Ugadi', 'Vishu'];
      case IndianRegion.eastIndia:
        return ['Durga Puja', 'Rath Yatra', 'Bihu', 'Chhath Puja'];
      case IndianRegion.westIndia:
        return ['Ganesh Chaturthi', 'Gudi Padwa', 'Navratri'];
      case IndianRegion.panIndia:
        return ['Diwali', 'Maha Shivratri', 'Janmashtami', 'Ram Navami'];
    }
  }
}
