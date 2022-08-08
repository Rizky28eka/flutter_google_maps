import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/page/maps_v1_page.dart';
import 'package:flutter_google_maps/page/maps_v2_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/maps.png'), fit: BoxFit.cover)),
            ),
          ),
          SafeArea(
            child: Container(
              constraints: const BoxConstraints.expand(height: double.infinity),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(50))),
              transform: Matrix4.rotationZ(0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/icon-google-maps.png'))),
                  ),
                  Text('in Flutter',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700])),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final route = MaterialPageRoute(
                            builder: (context) => MapsV1Page());
                        Navigator.push(context, route);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text(
                        'Google Maps v1',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        final route = MaterialPageRoute(
                            builder: (context) => MapsV2Page());
                        Navigator.push(context, route);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      child: const Text(
                        'Google Maps v2',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
