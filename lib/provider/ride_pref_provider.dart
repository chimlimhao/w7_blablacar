import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import 'package:flutter/material.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Initialize by loading past preferences from repository
    _pastPreferences = repository.getPastPreferences();
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

  void _addPreference(RidePreference preference) {
    // Step-01: Only add if it's not already in the history
    if (!_pastPreferences.contains(preference)) {
      // Step-02: Add to history
      _pastPreferences.add(preference);
    }
  }

  // Get the history of preferences and update it when a new preference is added
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
