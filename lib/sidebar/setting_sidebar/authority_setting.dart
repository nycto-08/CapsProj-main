import 'package:bantay_alertdraft/instruction_specialpop/logout_confirmation/logoutdialogbox.dart';
import 'package:bantay_alertdraft/sidebar/setting_sidebar/resident_account.dart';
import 'package:flutter/material.dart';

class AuthoritySetting extends StatelessWidget {
  const AuthoritySetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxisScrolled) => [
                SliverAppBar(
                  backgroundColor: const Color(0xFF7C0A20),
                  pinned: false,
                  floating: false,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon_settings.png",
                        color: Colors.white,
                        height: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "SETTINGS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          body: Builder(
            builder: (context) {
              final screenHeight = MediaQuery.of(context).size.height;

              return Stack(
                children: [
                  // Background gradient container
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFFFFFFF),
                          Color(0xFFEFEDED),
                          Color(0xFFD88990),
                          Color(0xFFDA7F88),
                        ],
                        stops: [0, 0.4, 0.77, 0.9, 1.0],
                      ),
                    ),
                  ),

                  // Centered column with the button
                  Positioned(
                    top: screenHeight * 0.08,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customButton(context, "Account", () {
                          navigateWithTransition(context, ResidentAccount());
                        }),
                        SizedBox(height: 5),
                        customButton(context, "Terms and Policies", () {}),
                        SizedBox(height: 5),
                        customButton(context, "Logout", () {
                          showAuthorityGetStartedLogoutDialog(context);
                        }),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget customButton(
    BuildContext context,
    String buttonText,
    VoidCallback onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
        backgroundColor: Color(0xFF7C0A20),
        minimumSize: Size(screenWidth * 0.8, 50),
      ),
      child: Container(
        width: screenWidth * 0.8,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ), // Internal padding
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
                fontFamily: 'RobotoBold',
              ),
            ),
            Positioned(
              right: 0,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateWithTransition(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          final fadeTween = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: curve));
          final scaleTween = Tween<double>(
            begin: 1.05,
            end: 1.0,
          ).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: offsetAnimation,
              child: ScaleTransition(
                scale: animation.drive(scaleTween),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
