import 'package:flutter/material.dart';

import '../../theme/theme.dart';

const String blablaWifiImagePath = 'assets/images/blabla_wifi.png';

class BlaError extends StatelessWidget {
  const BlaError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          blablaWifiImagePath,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 8),
        Text(
          message,
          style: BlaTextStyles.heading.copyWith(
            color: BlaColors.textNormal,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
