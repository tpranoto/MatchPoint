class Place {
  final String name;
  final String location;
  final String sportType;
  final double pricePerHour;
  final List<String> availableTimes;
  final List<String> imageFilenames;

  Place({
    required this.name,
    required this.location,
    required this.sportType,
    required this.pricePerHour,
    required this.availableTimes,
    required this.imageFilenames,
  });
}
