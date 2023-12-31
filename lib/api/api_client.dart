import '../consts/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import '../models/station.dart';

class ApiClient{
  Future<List<Station>> getStations() async{
    final response= await http.get(Uri.parse(constants.datasetUrlJson));
    if(response.statusCode==200){
      return List<Station>.from(jsonDecode(response.body)
          .map((stationJson) => Station.fromJson(stationJson))
          .toList());
    }else{
      throw Exception("failed to laod album");
    }
  }

  Image getGeoImageFromCoords(double lat, double lon, int width){
    return Image.network(
      "${constants.mapquestApiURL}?size=$width,$width&key=${constants.mapquestApiKey}&zoom=15&center=$lat,$lon&pois=1,$lat,$lon",
      loadingBuilder: (context, child, loadingProgress){
        if(loadingProgress==null) return child;
        return Center(
          child:  CircularProgressIndicator(
            value:   loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes! : null,
          ),

        );
      });
  }
}