import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation/repositories/geolocation/geolocation_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bloc.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GeolocationRepository>(
          create: (_) => GeolocationRepository(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future<void> changeIcon() async {
  //   markerIcon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(), 'assets/icons/marker.png');
  // }
  //
  // late BitmapDescriptor markerIcon;
  //
  // @override
  // void initState() {
  //   changeIcon();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => GeolocationBloc(
                repository: context.read<GeolocationRepository>())
              ..add(LoadGeolocation())),
      ],
      child: Scaffold(
        body: BlocBuilder<GeolocationBloc, GeolocationState>(
          builder: (context, state) {
            if (state is GeolocationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GeolocationLoaded) {
              return Gmap(
                lat: state.position.latitude,
                lng: state.position.longitude,
                // iconM: markerIcon,
              );
            } else {
              return const Center(
                child: Text('Oups'),
              );
            }
          },
        ),
      ),
    );
  }
}

class Gmap extends StatefulWidget {

  final double lat;
  final double lng;





  const Gmap({
    Key? key,
    required this.lat,
    required this.lng,
    // required this.iconM,
  }) : super(key: key);

  @override
  State<Gmap> createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  BitmapDescriptor? markerIcon;
  // final iconM;

  Future<void> changeIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/icons/marker.png');
    setState(() {

    });
  }

  @override
  void initState() {

    changeIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        markers: {
          Marker(
            markerId: const MarkerId('id-1'),
            position: const LatLng(54.725847, 55.949582),
            icon: markerIcon ?? BitmapDescriptor.defaultMarker ,
          ),
          Marker(
            markerId: const MarkerId('id-2'),
            position: const LatLng(54.725847, 55.941283),
            icon: markerIcon ?? BitmapDescriptor.defaultMarker,
          ),
          Marker(
            markerId: const MarkerId('id-3'),
            position: const LatLng(54.725847, 55.950284),
            icon:markerIcon ?? BitmapDescriptor.defaultMarker,
          ),
        },
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        // polygons: {
        //   Polygon(points: [
        //     LatLng(
        //       54.725654,
        //       55.949672,
        //     ),
        //     LatLng(
        //       54.725588,
        //       55.950001,
        //     )
        //   ])
        // },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 10,
        ),
        zoomControlsEnabled: true,
      ),
    );
  }
}
