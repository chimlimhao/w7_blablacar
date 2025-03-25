import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import '../../../provider/ride_pref_provider.dart';
import '../../../provider/async_value.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  onRidePrefSelected(RidePreference newPreference, BuildContext context) async {
    // 1 - Update the current preference
    final provider = context.watch<RidesPreferencesProvider>();
    provider.setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a buttom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when changes occur
    final provider = context.watch<RidesPreferencesProvider>();

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                      onSubmit: (newPreference) =>
                          onRidePrefSelected(newPreference, context)),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                    height: 200, // Set a fixed height

                    child: _buildPastPreferences(provider),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPastPreferences(RidesPreferencesProvider provider) {
    final pastPreferences = provider.preferencesHistory;

    switch (pastPreferences.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());

      case AsyncValueState.empty:
        return const Text('No past preferences');

      case AsyncValueState.error:
        return const Center(child: Text('Error loading past preferences'));

      case AsyncValueState.success:
        return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: pastPreferences.data!.length,
          itemBuilder: (ctx, index) => RidePrefHistoryTile(
            ridePref: pastPreferences.data![index],
            onPressed: () => {},
          ),
        );
    }
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
