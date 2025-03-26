import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
// import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/data/repository/local/local_ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> _pastPreferences = AsyncValue.empty();
  // final RidePreferencesRepository repository;
  final LocalRidePreferencesRepository localRepository;

  // RidesPreferencesProvider({required this.repository}) {
  //   // Initialize by loading past preferences from repository
  //   fetchPastPreferences();
  // }

  RidesPreferencesProvider({required this.localRepository}) {
    // Initialize by loading past preferences from local storage
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    // Step-01: Only process if the new preference is different
    if (pref != _currentPreference) {
      // Step-02: Update current preference
      _currentPreference = pref;

      // Step-03: Add to history if it's unique
      _addPreference(pref);

      // Step-04: Notify listeners of the change
      notifyListeners();
    }
  }

  Future<void> _addPreference(RidePreference preference) async {
    try {
      // Only proceed if we're in success state
      if (_pastPreferences.state == AsyncValueState.success) {
        // Step-01: Add to repository first (always save to storage)
        await localRepository.addPreference(preference);

        // Step-02: Update the local cache directly
        _pastPreferences.data!.add(preference);

        // Step-03: Notify listeners to update UI
        notifyListeners();
      } else {
        // If not in success state, do a full fetch
        await localRepository.addPreference(preference);
        await fetchPastPreferences();
      }
    } catch (e) {
      // Handle errors
      _pastPreferences = AsyncValue.error(e);
      notifyListeners();
    }
  }

  // Get the history of preferences and update it when a new preference is added
  AsyncValue<List<RidePreference>> get preferencesHistory {
    if (_pastPreferences.state == AsyncValueState.success &&
        _pastPreferences.data != null) {
      // Create a new list with reversed order (newest first)
      final reversedList =
          List<RidePreference>.from(_pastPreferences.data!.reversed);
      return AsyncValue.success(reversedList);
    }
    return _pastPreferences;
  }

  Future<void> fetchPastPreferences() async {
    _pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      final prefs = await localRepository.fetchPastPreferences();

      // Simulate an error for testing purposes
      // throw Exception("Failed to fetch past preferences");

      if (prefs.isEmpty) {
        _pastPreferences = AsyncValue.empty();
      } else {
        _pastPreferences = AsyncValue.success(prefs);
      }
    } catch (e) {
      _pastPreferences = AsyncValue.error(e);
    }
    notifyListeners();
  }
}
