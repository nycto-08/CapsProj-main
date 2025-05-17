import 'package:bantay_alertdraft/instruction_specialpop/authority_submit/authority_wait_accepted_page.dart';
import 'package:flutter/material.dart';

void showAuthoritySuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Rounded corners
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle, // Checkmark icon
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 5),
              const Text(
                "Success!",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 22,
                  fontFamily: 'RobotoBold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center, // Centers the text
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'MontserratMedium',
                    color: Colors.black, // Default text color
                  ),
                  children: [
                    const TextSpan(
                      text:
                          "You have successfully submitted your Bantay Alert ",
                    ),
                    TextSpan(
                      text: "AUTHORITY",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'FranklinGothicHeavy',
                        color: Color(0xFFA31321), // Red color
                        fontWeight: FontWeight.bold, // Bold
                      ),
                    ),
                    const TextSpan(
                      text: " Membership Application.\n\n",
                    ), // Extra space (2 new lines)
                    const TextSpan(
                      text:
                          "Your application will now be reviewed by your selected barangay.\n\n",
                    ),
                    const TextSpan(
                      text:
                          "You will be notified by email or through the application once your application has been reviewed by the selected barangay.",
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: SizedBox(
                width: 75, // Set a specific width
                height: 40, // Set a specific height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => AuthorityWaitAcceptedPage(),
                      ),
                    ); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.zero, // Remove extra padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Perfect rectangle
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 20, // Reduce text size slightly
                      fontFamily: 'Montserrat-ExtraBold',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
