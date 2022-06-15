import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/imgLoader.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/utils/snackbar.dart';

class TassieMap extends StatefulWidget {
  const TassieMap({required this.dp, required this.rightSwipe, Key? key})
      : super(key: key);
  final String dp;
  final void Function() rightSwipe;

  @override
  State<TassieMap> createState() => _TassieMapState();
}

class _TassieMapState extends State<TassieMap> {
  double lat = 51.5;
  double lng = -0.09;
  String message = "";
  bool isLoading = true;
  var storage = const FlutterSecureStorage();
  var dio = Dio();
  AsyncMemoizer memoizer = AsyncMemoizer();
  String profilePic = "";
  late Future storedFuture;

  Future<void> checkPermission() async {
    bool serviceEnabled;
    Location location = Location();
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        showSnack(context, 'please turn on location', () {}, 'OK', 4);
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        showSnack(context, 'please turn on location', () {}, 'OK', 4);
      }
    }
  }

  Future<void> getLocation() async {
    LocationData locationData;
    Location location = Location();
    locationData = await location.getLocation();

    if (mounted) {
      Provider.of<LeftSwipe>(context, listen: false).setSwipe(false);
      setState(() {
        lat = locationData.latitude!;
        lng = locationData.longitude!;
        isLoading = false;
      });
    }
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   setState(() {
    //     lat = currentLocation.latitude!;
    //     lng = currentLocation.longitude!;
    //     isLoading = false;
    //   });
    // });

    // setState((){
    //   location.onLocationChanged.listen((LocationData currentLocation) {
    //   lat = _locationData.latitude!;
    //   lng = _locationData.longitude!;
    //   isLoading=false;
    // });
    // });
    // print(lng);
    // print(lat);
    // print(locationData);
  }

  @override
  void initState() {
    memoizer = AsyncMemoizer();
    checkPermission();
    // getdp();
    getLocation();

    super.initState();
    storedFuture = loadImg(widget.dp, memoizer);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();
    return isLoading
        ? const Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 50.0,
            ),
          )
        : Scaffold(
            // appBar: AppBar(
            //   title: const Text('Live location'),
            //   centerTitle: true,
            //   backgroundColor: Colors.transparent,
            //   toolbarHeight: kToolbarHeight + 20.0,
            //   foregroundColor: kDark,
            // ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              foregroundColor: kPrimaryColor,
              onPressed: () {
                getLocation();
                // mapController
              },
              child: const Icon(Icons.my_location_rounded),
            ),
            body: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: LatLng(lat, lng),
                    zoom: 7.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      attributionBuilder: (_) {
                        return const Text(
                          "Tassie",
                          style: TextStyle(
                              fontSize: 12.0, fontFamily: 'LobsterTwo'),
                        );
                      },
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 48.0,
                          height: 48.0,
                          point: LatLng(lat, lng),
                          builder: (ctx) => ClipOval(
                            child: Material(
                              // child: Ink.image(
                              //   height: 128,
                              //   width: 128,
                              //   image:
                              //       CachedNetworkImageProvider('https://picsum.photos/200'),
                              //   fit: BoxFit.cover,
                              //   child: InkWell(
                              //     onTap: () {},
                              //   ),
                              // ),
                              child: FutureBuilder(
                                  future: storedFuture,
                                  builder: (BuildContext context,
                                      AsyncSnapshot text) {
                                    if ((text.connectionState ==
                                            ConnectionState.waiting) ||
                                        text.hasError) {
                                      return Image.asset(
                                          "assets/images/broken.png",
                                          fit: BoxFit.cover,
                                          height: 48,
                                          width: 48);
                                    } else {
                                      if (!text.hasData) {
                                        return const SizedBox(
                                            height: 48,
                                            width: 48,
                                            child: Center(
                                              child: Icon(
                                                Icons.refresh,
                                                // size: 50.0,
                                                color: kDark,
                                              ),
                                            ));
                                      }
                                      return Ink.image(
                                        height: 48,
                                        width: 48,
                                        image: CachedNetworkImageProvider(
                                            text.data.toString()),
                                        fit: BoxFit.cover,
                                        child: InkWell(
                                          onTap: () {},
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: kDefaultPadding,
                  right: kDefaultPadding * 2 + 100.0,
                  left: kDefaultPadding,
                  child: GestureDetector(
                    onTap: () => widget.rightSwipe(),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        shadowColor: kPrimaryColorAccent,
                        color: kPrimaryColor,
                        elevation: 5.0,
                        child: const Center(
                          child: Text(
                            'BACK TO FEED',
                            style: TextStyle(
                              // fontFamily: 'Raleway',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
