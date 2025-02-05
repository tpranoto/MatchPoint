import 'package:flutter/widgets.dart';
import 'package:matchpoint/models/place.dart';
import 'package:matchpoint/models/sample_data.dart';

class PlaceProvider extends ChangeNotifier {
  List<Place> _listOfPlaces = populatedPlaces;

  List<Place> get getList {
    return [..._listOfPlaces];
  }

  addList(List<Place> places) {
    _listOfPlaces.addAll(places);
    notifyListeners();
  }

  replaceList(List<Place> places) {
    _listOfPlaces = places;
    notifyListeners();
  }
}
