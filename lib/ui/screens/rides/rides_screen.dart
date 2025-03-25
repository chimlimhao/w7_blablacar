import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../provider/ride_pref_provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the provider to get updates
    final prefProvider = context.watch<RidesPreferencesProvider>();
    final currentPreference = prefProvider.currentPreference;

    // You might want to move this to the provider as well
    final currentFilter = RideFilter();
    final matchingRides =
        RidesService.instance.getRidesFor(currentPreference!, currentFilter);

    void onBackPressed() {
      Navigator.of(context).pop();
    }

    void onPreferencePressed() async {
      // Open a modal to edit the ride preferences
      RidePreference? newPreference =
          await Navigator.of(context).push<RidePreference>(
        AnimationUtils.createTopToBottomRoute(
          RidePrefModal(initialPreference: currentPreference),
        ),
      );

      if (newPreference != null) {
        // Update the preference through the provider instead of service
        prefProvider.setCurrentPreference(newPreference);
      }
    }

    void onFilterPressed() {
      // Implement filter logic here
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: onBackPressed,
              onPreferencePressed: onPreferencePressed,
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
