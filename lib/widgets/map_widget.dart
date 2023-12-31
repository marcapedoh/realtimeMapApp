import 'package:flutter/material.dart';
import 'package:realtimemapapp/api/api_client.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  ApiClient client =ApiClient();

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: _getMapImage());
  }

  Widget _getMapImage(){
    int width=(MediaQuery.of(context).size.width.toInt()*0.8).toInt();
    return client.getGeoImageFromCoords(widget.latitude, widget.longitude, width);
  }
}
