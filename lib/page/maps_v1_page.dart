import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_google_maps/models/map_type_google.dart';
import 'package:flutter_google_maps/utils/data_dummy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsV1Page extends StatefulWidget {
  const MapsV1Page({Key? key}) : super(key: key);

  @override
  State<MapsV1Page> createState() => _MapV1PageState();
}

class _MapV1PageState extends State<MapsV1Page> {
  final Completer<GoogleMapController> _controller = Completer();

  double latitude = -6.201491067098624;
  double longitude = 106.82126029714837;

  var mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Maps V1",
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

          //Place Card
          _buildDetailCard()
        ],
      ),
    );
  }

  _buildMaps() => GoogleMap(
        mapType: mapType,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 17),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
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

  _buildDetailCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://idn.sch.id/wp-content/uploads/2016/10/ima-studio.png",
                "ImaStudio",
                -6.1952988,
                106.7926625),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://2.bp.blogspot.com/-0WirdbkDv4U/WxUkajG0pAI/AAAAAAAADNA/FysRjLMqCrw_XkcU0IQwuqgKwXaPpRLRgCLcBGAs/s1600/1528109954774.jpg",
                "Monas",
                -6.1753871,
                106.8249587),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://cdn1-production-images-kly.akamaized.net/n8uNqIv9lZ3PJVYw-8rfy8DZotE=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/925193/original/054708200_1436525200-6-Masjid-Megah-Istiqlal.jpg",
                "Masjid Istiqlal",
                -6.1702229,
                106.8293614),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://img-z.okeinfo.net/library/images/2018/08/14/gtesxf7d7xil1zry76xn_14364.jpg",
                "Istana Merdeka",
                -6.1701238,
                106.8219881),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://id2-cdn.pgimgs.com/listing/19424566/UPHO.112356433.V800/Perumahan-Duta-Harapan-Bekasi-Indonesia.jpg",
                "Rumah Bekasi",
                -6.213101380590407,
                107.01466704580294),
          ],
        ),
      ),
    );
  }

  Widget _displayPlaceCard(
      String imageUrl, String name, double lat, double lng) {
    return GestureDetector(
      onTap: () {
        _onClickPlaceCard(lat, lng);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 90,
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          elevation: 10,
          child: Row(children: [
            Container(
              width: 90,
              height: 90,
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text(
                        "4.9",
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: stars(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Indonesia \u00B7 Jakarta Barat",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const Text(
                    "Closed \u00B7 Open 09.00 Monday",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  List<Widget> stars() {
    List<Widget> list1 = [];
    for (var i = 0; i < 5; i++) {
      list1.add(const Icon(
        Icons.star,
        color: Colors.orange,
        size: 15,
      ));
    }
    return list1;
  }

  void _onClickPlaceCard(double lat, double lng) async {
    setState(() {
      latitude = lat;
      longitude = lng;
    });

    GoogleMapController controller = await _controller.future;
    final cameraPosition = CameraPosition(
        target: LatLng(latitude, longitude), zoom: 17, tilt: 55, bearing: 192);
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    controller.animateCamera(cameraUpdate);
  }
}
