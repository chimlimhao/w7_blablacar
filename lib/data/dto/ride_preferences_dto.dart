import 'location_dto.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class RidePreferenceDto {
  final LocationDto departure;
  final LocationDto arrival;
  final DateTime departureDate;
  final int requestedSeats;

  RidePreferenceDto({
    required this.departure,
    required this.arrival,
    required this.departureDate,
    required this.requestedSeats,
  });

  static Map<String, dynamic> toJson(RidePreference preference) {
    return {
      'departure': LocationDto.toJson(preference.departure),
      'arrival': LocationDto.toJson(preference.arrival),
      'departureDate': preference.departureDate.toIso8601String(),
      'requestedSeats': preference.requestedSeats,
    };
  }

  static RidePreference fromJson(Map<String, dynamic> json) {
    return RidePreference(
      departure: LocationDto.fromJson(json['departure']),
      arrival: LocationDto.fromJson(json['arrival']),
      departureDate: DateTime.parse(json['departureDate']),
      requestedSeats: json['requestedSeats'],
    );
  }
}
