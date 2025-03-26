import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import '../../provider/ride_pref_provider.dart';
import '../../../ui/screens/error/bla_error_screen.dart';

import '../../provider/async_value.dart';
import '../../../ui/widgets/actions/bla_button.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  onRidePrefSelected(RidePreference newPreference, BuildContext context) {
    // 1 - Update the current preference
    final provider = context.read<RidesPreferencesProvider>();
    provider.setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a buttom to top animation)
    Navigator.of(context)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Your pick of rides at low price",
                    style: BlaTextStyles.heading.copyWith(color: Colors.white),
                  ),
                ),

                // Developer menu for Firebase operations
                IconButton(
                  icon: Icon(Icons.developer_mode, color: Colors.white),
                  onPressed: () {
                    _showDeveloperMenu(context);
                  },
                ),
              ],
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
                  RidePrefForm(initialPreference: provider.currentPreference),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                    height: 350, // Set a fixed height

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
        return const Center(child: Text('No past preferences'));

      case AsyncValueState.error:
        return SizedBox(
          height: 180,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlaError(message: 'Error loading past preferences'),
                SizedBox(height: 10),
                BlaButton(
                  text: 'Retry',
                  type: ButtonType.primary,
                  onPressed: () => provider.fetchPastPreferences(),
                ),
              ],
            ),
          ),
        );

      case AsyncValueState.success:
        return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: pastPreferences.data!.length,
          itemBuilder: (ctx, index) => RidePrefHistoryTile(
            ridePref: pastPreferences.data![index],
            onPressed: () =>
                onRidePrefSelected(pastPreferences.data![index], ctx),
          ),
        );
    }
  }

  // Developer menu for Firebase operations
  void _showDeveloperMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Firebase Developer Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.cloud_upload),
                title: Text('Seed Firebase with sample locations'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    // Show loading indicator
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Seeding Firebase data...'),
                        duration: Duration(milliseconds: 1000),
                      ),
                    );

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Firebase data seeded successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error seeding Firebase data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
