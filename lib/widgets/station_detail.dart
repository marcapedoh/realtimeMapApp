import 'package:flutter/material.dart';
import 'package:realtimemapapp/models/station.dart';
import 'package:realtimemapapp/widgets/map_widget.dart';

import '../consts/constants.dart';
import '../utils/string_utils.dart';

class StationDetails extends StatefulWidget {

  final Station station;
  const StationDetails({ required Key key, required this.station})
      : super(key: key);

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.station.commune}, ${widget.station.name}")
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                "Station ${StringUtils.toCalmelCase(widget.station.name)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: Text(
                "Commune de ${StringUtils.toCalmelCase(widget.station.commune)}",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Column(
              children: <Widget>[
                const Text(
                  "Statut",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  StringUtils.toCalmelCase(widget.station.status),
                  style: widget.station.status == "EN SERVICE"
                      ? const TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)
                      : const TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget> [
                    const Text(
                      "Places disponibles",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${widget.station.nbPlacesVelopsDispo}",
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Column(
                  children: <Widget> [
                    const Text(
                      "velos disponibles",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.station.nbVelosDispo==0
                          ? "Plus de vélos disponibles"
                          : "${widget.station.nbVelosDispo}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Column(
              children: <Widget>[
                const Text(
                  "Adresse",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${StringUtils.toCalmelCase(widget.station.adress)}, ${StringUtils.toCalmelCase(widget.station.commune)}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            MapWidget(
                key: UniqueKey(),
                latitude: widget.station.coordinates.latitude,
                longitude: widget.station.coordinates.longitude),
            const SizedBox(
              height: 15,
            ),
            RichText(
                text: TextSpan(
                  text: "Dernière mise à jour le ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: StringUtils.formatDateTime(widget.station.lastUpdate),
                      style: const TextStyle(fontStyle: FontStyle.italic)
                    ),
                  ],
              )
            )

          ],
          ),
        ),
      ),
    );
  }


}
