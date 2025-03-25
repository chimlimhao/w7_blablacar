import 'package:flutter/material.dart';
import 'repository/mock/mock_ride_preferences_repository.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'provider/ride_pref_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Rides Preferences Provider
        ChangeNotifierProvider(
          create: (context) => RidesPreferencesProvider(
            repository: MockRidePreferencesRepository(),
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
