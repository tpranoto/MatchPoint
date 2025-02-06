enum SportsCategories {
  all,
  badminton, //52e81612bcbc57f1066b7a2b
  basketball, //4bf58dd8d48988d1e1941735
  soccer, //4cce455aebf7b749d5e191f5
  squash, //52e81612bcbc57f1066b7a2d
  tennis, //4e39a956bd410d7aed40cbc3
  volleyball, //4eb1bf013b7b6f98df247e07
}

extension SportsCategoriesData on SportsCategories {
  String get categoryString {
    switch (this) {
      case SportsCategories.all:
        return "All";
      case SportsCategories.badminton:
        return "Badminton";
      case SportsCategories.basketball:
        return "Basketball";
      case SportsCategories.soccer:
        return "Soccer";
      case SportsCategories.squash:
        return "Squash";
      case SportsCategories.tennis:
        return "Tennis";
      case SportsCategories.volleyball:
        return "Volleyball";
    }
  }

  String get category4SCode {
    switch (this) {
      case SportsCategories.all:
        return "52e81612bcbc57f1066b7a2b,4bf58dd8d48988d1e1941735,4cce455aebf7b749d5e191f5,52e81612bcbc57f1066b7a2d,4e39a956bd410d7aed40cbc3,4eb1bf013b7b6f98df247e07";
      case SportsCategories.badminton:
        return "52e81612bcbc57f1066b7a2b";
      case SportsCategories.basketball:
        return "4bf58dd8d48988d1e1941735";
      case SportsCategories.soccer:
        return "4cce455aebf7b749d5e191f5";
      case SportsCategories.squash:
        return "52e81612bcbc57f1066b7a2d";
      case SportsCategories.tennis:
        return "4e39a956bd410d7aed40cbc3";
      case SportsCategories.volleyball:
        return "4eb1bf013b7b6f98df247e07";
    }
  }

  int get categoryBasedPrice {
    switch (this) {
      case SportsCategories.badminton:
        return 1600;
      case SportsCategories.basketball:
        return 4000;
      case SportsCategories.soccer:
        return 6500;
      case SportsCategories.squash:
        return 1400;
      case SportsCategories.tennis:
        return 3000;
      case SportsCategories.volleyball:
        return 3500;
      default:
        return 1300;
    }
  }
}

SportsCategories categoryEnum(String category) {
  switch (category) {
    case "Badminton Court":
    case "Badminton":
      return SportsCategories.badminton;
    case "Basketball Court":
    case "Basketball":
      return SportsCategories.basketball;
    case "Soccer Field":
    case "Soccer":
      return SportsCategories.soccer;
    case "Squash Court":
    case "Squash":
      return SportsCategories.squash;
    case "Tennis Court":
    case "Tennis":
      return SportsCategories.tennis;
    case "Volleyball Court":
    case "Volleyball":
      return SportsCategories.volleyball;
    default:
      return SportsCategories.all;
  }
}
