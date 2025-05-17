import 'package:bantay_alertdraft/login_pages/home_rolepage.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showGetStartedLogoutDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF414042)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C0A20),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Clear focus to prevent input issues
              FocusManager.instance.primaryFocus?.unfocus();

              // Clear provider and shared preferences
              Provider.of<ResidentVariable>(context, listen: false).clearData();
              final preference = await SharedPreferences.getInstance();
              await preference.remove('_residents_email');

              Navigator.of(dialogContext).pop();

              // Use this to completely reset the navigation stack
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeRolePage()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

Future<void> showAuthorityGetStartedLogoutDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF414042)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C0A20),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Clear focus to prevent input issues
              FocusManager.instance.primaryFocus?.unfocus();

              // Clear provider and shared preferences
              Provider.of<AuthorityVariable>(
                context,
                listen: false,
              ).clearData();
              final preference = await SharedPreferences.getInstance();
              await preference.remove('_authorities_email');

              Navigator.of(dialogContext).pop();

              // Use this to completely reset the navigation stack
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeRolePage()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
