import 'package:week_3_blabla_project/model/location/locations.dart';

class LocationDto {
  final String name;
  final String country;

  LocationDto({
    required this.name,
    required this.country,
  });

  static Map<String, dynamic> toJson(Location location) {
    return {
      'name': location.name,
      'country': location.country.name,
    };
  }

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      country: countryFromString(json['country']),
    );
  }

  static Country countryFromString(String country) {
    return Country.values.firstWhere((e) => e.name == country);
  }
}
