import '../model/ride/ride_pref.dart';

abstract class RidePreferencesRepository {
  Future<List<RidePreference>> fetchPastPreferences();

  Future<void> addPreference(RidePreference preference);
}
