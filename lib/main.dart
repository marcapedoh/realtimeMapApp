import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:realtimemapapp/api/api_client.dart';
import 'package:realtimemapapp/models/station.dart';
import 'package:realtimemapapp/widgets/station_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V\'Lille',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'V\'Lille Stations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  /// Stations from the API call
  late Future<List<Station>> futureStations;

  /// Stations to display in the list
  List<Station> stationsDisplayed = [];

  /// Api client
  ApiClient client = ApiClient();

  /// Is the user looking for his favorite stations?
  bool isFavFilterActive = false;

  void getFavoritesStationsFromSP() async {
    prefs = await SharedPreferences.getInstance();
    List<String> favStations = prefs.getStringList('favStations') ?? [];

    // Update the stations that are in the favorite list
    setState(() {
      futureStations.then((value) => value
          .where((element) => favStations.contains(element.name))
          .map((e) => e.isFavorite = true)
          .toList());
    });
  }

  void setStationFavorite(String stationName, bool isFavorite) async {
    prefs = await SharedPreferences.getInstance();
    List<String> favStations = prefs.getStringList('favStations') ?? [];
    if (isFavorite) {
      favStations.add(stationName);
    } else {
      favStations.remove(stationName);
    }
    prefs.setStringList('favStations', favStations);
  }

  @override
  void initState() {
    super.initState();

    // Remove the splash screen
    FlutterNativeSplash.remove();

    // Get the stations from the API
    futureStations = client.getStations();

    // Get the favorites stations from the local storage
    // And updates the stations list
    getFavoritesStationsFromSP();

    // Set the stations to be shown in the list
    futureStations.then((value) {
      setState(() {
        stationsDisplayed = value;
      });
    });
  }

  @override
  // build a search bar that will filter the list of stations
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Chercher une station',
              ),
              onChanged: (searchValue) {
                _filterStations(futureStations, searchValue);
              },
            ),
          ),
          Expanded(
            child: () {
              if (stationsDisplayed.isEmpty && !isFavFilterActive) {
                return const Center(child: CircularProgressIndicator());
              } else if (stationsDisplayed.isEmpty && isFavFilterActive) {
                return const Center(
                    child: Text(
                        'Aucune station favorite.\n\nPour ajouter une station aux favoris,\ncliquez sur l\'étoile dans la page de résultats.',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true));
              } else {
                return ListView.builder(
                    itemCount: stationsDisplayed.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                            title: Text(stationsDisplayed[index].name),
                            leading: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: stationsDisplayed[index].isFavorite
                                        ? const Icon(Icons.star,
                                        color: Colors.red, size: 30)
                                        : const Icon(Icons.star_border,
                                        color: Colors.red, size: 30),
                                    onTap: () {
                                      setState(() {
                                        // Update the station in the list
                                        stationsDisplayed[index].isFavorite =
                                        !stationsDisplayed[index].isFavorite;

                                        // Update the favorite stations in the shared preferences
                                        setStationFavorite(
                                            stationsDisplayed[index].name,
                                            stationsDisplayed[index].isFavorite);
                                      });
                                    },
                                  )
                                ]),
                            subtitle: Text(
                                "${stationsDisplayed[index].commune}, ${stationsDisplayed[index].adress.toUpperCase()}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(children: [
                                  Text(
                                      "${stationsDisplayed[index].nbVelosDispo > 0 ? stationsDisplayed[index].nbVelosDispo : "Aucun"} vélo${stationsDisplayed[index].nbVelosDispo > 1 ? "s" : ""}"),
                                  const Icon(Icons.directions_bike),
                                ]),
                                const Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, _, __) =>
                                          StationDetails(
                                              key: UniqueKey(),
                                              station: stationsDisplayed[index]),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      }));
                            },
                          ));
                    });
              }
            }(),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isFavFilterActive = !isFavFilterActive;
              futureStations.then((stations) {
                if (isFavFilterActive) {
                  stationsDisplayed =
                      stations.where((element) => element.isFavorite).toList();
                } else {
                  stationsDisplayed = stations;
                }
              });
            });
          },
          tooltip: 'Favoris',
          child: isFavFilterActive
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border),
        ));
  }

  /// Filter the list of stations based on the search value & atleast 1 bike avaible
  /// and update the list of stations displayed
  void _filterStations(Future<List<Station>> stations, String searchValue) {
    setState(() {
      stations.then((value) => stationsDisplayed = value
          .where((element) =>
      element.name.toLowerCase().contains(searchValue.toLowerCase()) &&
          element.nbVelosDispo > 0)
          .toList());
    });
  }
}
