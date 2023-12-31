import 'dart:html';
import 'coordinates.dart';
class Station{
  bool isFavorite=false;
  String name,adress,status,commune;
  int nbVelosDispo,nbPlacesVelopsDispo;
  DateTime lastUpdate;
  Coordinates coordinates;
  Station({
    required this.name,
    required this.adress,
    required this.status,
    required this.commune,
    required this.nbVelosDispo,
    required this.nbPlacesVelopsDispo,
    required this.lastUpdate,
    required this.coordinates
});
  
  factory Station.fromJson(jsonDecode){
    return Station(name: jsonDecode['fields']['nom'],
        adress: jsonDecode['fields']['adresse'],
        status: jsonDecode['fields']['etat'],
        commune: jsonDecode['fields']['commune'],
        nbVelosDispo: jsonDecode['fields']['nbvelosdispo'],
        nbPlacesVelopsDispo: jsonDecode['fields']['nbplacesdispo'],
        lastUpdate: DateTime.parse(jsonDecode['fields']['datemiseajour']),
        coordinates: Coordinates.fromJson(jsonDecode));
  }
}