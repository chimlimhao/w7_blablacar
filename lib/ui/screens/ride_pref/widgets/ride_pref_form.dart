import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/ride/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../../utils/date_time_util.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../widgets/display/bla_divider.dart';
import 'ride_pref_input_tile.dart';
import '../../../provider/ride_pref_provider.dart';
import '../../../widgets/inputs/bla_location_picker.dart';
import '../../../../utils/animations_util.dart';
import '../../../../model/location/locations.dart';
import '../../../screens/rides/rides_screen.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  // Local form state
  Location? _departure;
  Location? _arrival;
  DateTime _departureDate = DateTime.now();
  int _requestedSeats = 1;

  @override
  void initState() {
    super.initState();
    // Initialize with provider values if they exist
    final prefProvider = context.read<RidesPreferencesProvider>();
    if (prefProvider.currentPreference != null) {
      _departure = prefProvider.currentPreference!.departure;
      _arrival = prefProvider.currentPreference!.arrival;
      _departureDate = prefProvider.currentPreference!.departureDate;
      _requestedSeats = prefProvider.currentPreference!.requestedSeats;
    }
  }

  void onDeparturePressed() async {
    // Just update local state for the form
    final selectedLocation = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(initLocation: _departure),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _departure = selectedLocation;
      });
    }
  }

  void onArrivalPressed() async {
    // Just update local state for the form
    final selectedLocation = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(initLocation: _arrival),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _arrival = selectedLocation;
      });
    }
  }

  void onSearch() {
    // Only create RidePreference and update provider when actually searching
    if (_departure != null && _arrival != null) {
      final newPreference = RidePreference(
        departure: _departure!,
        arrival: _arrival!,
        departureDate: _departureDate,
        requestedSeats: _requestedSeats,
      );
      Navigator.of(context).push<RidePreference>(
          AnimationUtils.createBottomToTopRoute(RidesScreen()));
      context
          .read<RidesPreferencesProvider>()
          .setCurrentPreference(newPreference);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                isPlaceHolder: _departure == null,
                title: _departure != null ? _departure!.name : "Leaving from",
                leftIcon: Icons.location_on,
                onPressed: onDeparturePressed,
              ),
              const BlaDivider(),

              // 2 - Input the ride arrival
              RidePrefInputTile(
                isPlaceHolder: _arrival == null,
                title: _arrival != null ? _arrival!.name : "Going to",
                leftIcon: Icons.location_on,
                onPressed: onArrivalPressed,
              ),
              const BlaDivider(),

              // 3 - Input the ride date
              RidePrefInputTile(
                  title: DateTimeUtils.formatDateTime(_departureDate),
                  leftIcon: Icons.calendar_month,
                  onPressed: () => {}),
              const BlaDivider(),

              // 4 - Input the requested number of seats
              RidePrefInputTile(
                title: _requestedSeats.toString(),
                leftIcon: Icons.person_2_outlined,
                onPressed: () => {},
              ),
            ],
          ),
        ),

        // 5 - Launch a search
        BlaButton(text: 'Search', onPressed: onSearch),
      ],
    );
  }
}
