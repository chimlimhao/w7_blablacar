import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';
import '../../../data/dto/ride_preferences_dto.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> fetchPastPreferences() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      // 1. Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // 2. Get the string list from storage, default to empty list if null
      final prefsList = prefs.getStringList(_preferencesKey) ?? [];

      // 3. Convert each JSON string to RidePreference using DTO
      final result = prefsList.map((json) {
        try {
          final decoded = jsonDecode(json);
          return RidePreferenceDto.fromJson(decoded);
        } catch (e) {
          throw Exception("Error parsing preference: $e");
        }
      }).toList();

      return result;
    } catch (e) {
      throw Exception("Error fetching past preferences: $e");
    }
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      // 1. Get current preferences
      final prefs = await SharedPreferences.getInstance();
      final currentPrefs = prefs.getStringList(_preferencesKey) ?? [];

      // 2. Convert preference to JSON string using DTO
      final json = RidePreferenceDto.toJson(preference);
      final preferenceJson = jsonEncode(json);

      // 3. Add new preference to list
      currentPrefs.add(preferenceJson);

      // 4. Save updated list back to SharedPreferences
      await prefs.setStringList(_preferencesKey, currentPrefs);
    } catch (e) {
      throw Exception("Error adding preference: $e");
    }
  }
}
