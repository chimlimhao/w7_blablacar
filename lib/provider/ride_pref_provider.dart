import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/provider/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>>? _pastPreferences;
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Initialize by loading past preferences from repository
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
    // Step-01: Only add if it's not already in the history
    if (!_pastPreferences!.data!.contains(preference)) {
      // Step-02: Add to history/repository
      await repository.addPreference(preference);

      // Step-03: Update the history local cache
      _pastPreferences!.data!.add(preference);

      // Step-04: Notify listeners of the change
      notifyListeners();
    }
  }

  // Get the history of preferences and update it when a new preference is added
  AsyncValue<List<RidePreference>> get preferencesHistory => _pastPreferences!;

  Future<void> fetchPastPreferences() async {
    _pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      final prefs = await repository.fetchPastPreferences();

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
