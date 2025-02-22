enum TimeSlot {
  first(Duration(hours: 7)),
  second(Duration(hours: 8)),
  third(Duration(hours: 9)),
  fourth(Duration(hours: 10)),
  fifth(Duration(hours: 11)),
  sixth(Duration(hours: 12)),
  seventh(Duration(hours: 13)),
  eighth(Duration(hours: 14)),
  ninth(Duration(hours: 15)),
  tenth(Duration(hours: 16)),
  eleventh(Duration(hours: 17)),
  twelfth(Duration(hours: 18)),
  thirteenth(Duration(hours: 19)),
  fourteenth(Duration(hours: 20));

  final Duration time;

  const TimeSlot(this.time);
}
