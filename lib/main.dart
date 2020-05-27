import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
//import 'package:googlemapexample/src/locations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
//  void _onMapCreated(GoogleMapController controller){
//    mapController = controller;
//
//  }

  final Map<String,Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Google map Demo"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
//        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),

          initialCameraPosition: CameraPosition(
            target: const LatLng(0, 0),
            zoom: 2,
          ),
        markers: _markers.values.toSet(),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
