import 'package:flutter/material.dart';
// import 'data/repository/mock/mock_ride_preferences_repository.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'ui/provider/ride_pref_provider.dart';
import 'service/locations_service.dart';
import 'service/rides_service.dart';
import 'data/repository/mock/mock_locations_repository.dart';
import 'data/repository/mock/mock_rides_repository.dart';
import 'data/repository/local/local_ride_preferences_repository.dart';

void main() {
  // 1 - Initialize the services(temporarily)
  LocationsService.initialize(MockLocationsRepository());
  RidesService.initialize(MockRidesRepository());

  runApp(
    MultiProvider(
      providers: [
        // Rides Preferences Provider
        ChangeNotifierProvider(
          create: (context) => RidesPreferencesProvider(
            // repository: MockRidePreferencesRepository(),
            localRepository: LocalRidePreferencesRepository(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(body: RidePrefScreen()),
      ),
    );
  }
}
