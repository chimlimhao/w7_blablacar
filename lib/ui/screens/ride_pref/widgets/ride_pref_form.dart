import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/ride/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../../utils/date_time_util.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../widgets/display/bla_divider.dart';
import 'ride_pref_input_tile.dart';
import '../../../provider/ride_pref_provider.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatelessWidget {
  const RidePrefForm({
    super.key,
    required this.onSubmit,
  });

  final Function(RidePreference preference) onSubmit;

  @override
  Widget build(BuildContext context) {
    // Get access to the provider
    final prefProvider = context.watch<RidesPreferencesProvider>();

    // Get current values from provider instead of local state
    final departure = prefProvider.currentPreference?.departure;
    final arrival = prefProvider.currentPreference?.arrival;
    final departureDate =
        prefProvider.currentPreference?.departureDate ?? DateTime.now();
    final requestedSeats = prefProvider.currentPreference?.requestedSeats ?? 1;

    void onSubmit() {
      if (departure != null && arrival != null) {
        final newPreference = RidePreference(
          departure: departure,
          departureDate: departureDate,
          arrival: arrival,
          requestedSeats: requestedSeats,
        );

        // Update the provider instead of using local callback
        prefProvider.setCurrentPreference(newPreference);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
          child: Column(
            children: [
              // 1 - Input the ride departure
              RidePrefInputTile(
                isPlaceHolder: departure == null,
                title: departure != null ? departure.name : "Leaving from",
                leftIcon: Icons.location_on,
                onPressed: () => {},
              ),
              const BlaDivider(),

              // 2 - Input the ride arrival
              RidePrefInputTile(
                isPlaceHolder: arrival == null,
                title: arrival != null ? arrival.name : "Going to",
                leftIcon: Icons.location_on,
                onPressed: () => {},
              ),
              const BlaDivider(),

              // 3 - Input the ride date
              RidePrefInputTile(
                title: DateTimeUtils.formatDateTime(departureDate),
                leftIcon: Icons.calendar_month,
                onPressed: () => {},
              ),
              const BlaDivider(),

              // 4 - Input the requested number of seats
              RidePrefInputTile(
                title: requestedSeats.toString(),
                leftIcon: Icons.person_2_outlined,
                onPressed: () => {},
              ),
            ],
          ),
        ),

        // 5 - Launch a search
        BlaButton(text: 'Search', onPressed: onSubmit),
      ],
    );
  }
}
