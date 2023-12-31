class Coordinates{

  double latitude, longitude;
  Coordinates({required this.latitude,required this.longitude});

  factory Coordinates.fromJson(jsonDecode){
    return Coordinates(
      latitude: jsonDecode['fields']['localisation'][0],
      longitude: jsonDecode['fields']['localisation'][1],
    );
  }
}