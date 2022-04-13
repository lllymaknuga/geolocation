import 'package:geolocator/geolocator.dart';

import 'base_geoloctaion_repository.dart';

class GeolocationRepository extends BaseGeolocationRepository {
  GeolocationRepository();
  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<Position> getCurrentLocation() async {
    _determinePosition();
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }
}
