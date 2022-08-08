import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_google_maps/models/map_type_google.dart';
import 'package:flutter_google_maps/utils/data_dummy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsV2Page extends StatefulWidget {
  const MapsV2Page({Key? key}) : super(key: key);

  @override
  State<MapsV2Page> createState() => _MapsV2PageState();
}

class _MapsV2PageState extends State<MapsV2Page> {
  var mapType = MapType.normal;
  double latitude = -6.201491067098624;
  double longitude = 106.82126029714837;
  Position? devicePosisition;
  late GoogleMapController _controller;

  String? address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Maps V2",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton(
              onSelected: onSelectedMapType,
              itemBuilder: (context) => googleMapTypes
                  .map((mapType) => PopupMenuItem(
                      value: mapType.title, child: Text(mapType.title)))
                  .toList())
        ],
      ),
      body: Stack(
        children: [
          //Google Maps
          _buildMaps(),
          //Search Card
          _buildSearchCard()
        ],
      ),
    );
  }

  _buildSearchCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: Column(children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 4),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Masukkan alamat...',
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchLocation();
                      },
                      icon: const Icon(Icons.search),
                    )),
                onChanged: (value) {
                  address = value;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  getLocation().then((value) {
                    setState(() {
                      devicePosisition = value;
                    });

                    final deviceLat = devicePosisition?.latitude;
                    final devicelng = devicePosisition?.longitude;

                    final cameraPosition = CameraPosition(
                        target: LatLng(deviceLat!, devicelng!), zoom: 17);
                    final cameraUpdate =
                        CameraUpdate.newCameraPosition(cameraPosition);
                    _controller.animateCamera(cameraUpdate);
                  });
                },
                child: const Text("Get My Location")),
            const SizedBox(
              height: 8,
            ),
            devicePosisition == null
                ? const Text("Lokasi Belum Terdeteksi")
                : Text(
                    "Mylocation ${devicePosisition?.latitude}${devicePosisition?.longitude}")
          ]),
        ),
      ),
    );
  }

  _buildMaps() => GoogleMap(
        mapType: mapType,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 17),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      );

  void onSelectedMapType(String value) {
    setState(() {
      if (value == "Normal") {
        mapType = MapType.normal;
      } else if (value == "Hybrid") {
        mapType = MapType.hybrid;
      } else if (value == "Terrain") {
        mapType = MapType.terrain;
      } else if (value == "Satellite") {
        mapType = MapType.satellite;
      }
    });
  }

  Future requestPermission() async {
    await Permission.location.request();
  }

  Future<Position?> getLocation() async {
    Position? currentPosisition;

    try {
      currentPosisition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentPosisition = null;
      rethrow;
    }

    return currentPosisition;
  }

  Future searchLocation() async {
    try {
      await GeocodingPlatform.instance
          .locationFromAddress(address!)
          .then((value) {
        final lat = value[0].latitude;
        final lng = value[0].longitude;
        final target = LatLng(lat, lng);
        final cameraPosition = CameraPosition(target: target, zoom: 17);
        final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
        return _controller.animateCamera(cameraUpdate);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Lokasi Tidak Ditemukan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 10);
    }
  }
}
