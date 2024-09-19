import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> request_position() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }
  return await Geolocator.getCurrentPosition();
}

Future<List<Placemark>> get_address_from_position({
  double? lat,
  double? long,
}) async {
  if (lat == null || long == null) {
    Position? position = await request_position();

    if (position != null) {
      lat = position.latitude;
      long = position.longitude;
    }
  }

  List<Placemark> placemarks = [];

  if (lat != null && long != null) {
    placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );
  }
  return placemarks;
}
