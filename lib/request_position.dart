import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Position> request_position() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<List<Placemark>> get_address_from_position(
  double? lat,
  double? long,
) async {
  if (lat == null || long == null) {
    Position position = await request_position();
    lat = position.latitude;
    long = position.longitude;
  }
  List<Placemark> placemarks = await placemarkFromCoordinates(
    lat,
    long,
  );
  return placemarks;
}
