import 'package:bantay_alertdraft/sidebar/authority_wait_accepted_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthorityWaitAcceptedPage extends StatelessWidget {
  AuthorityWaitAcceptedPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Scaffold(
            key: _scaffoldKey,
            drawer: AuthorityWaitAcceptedSidebar(),
            body: Stack(
              children: [
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
                        Color(0xFFA31321),
                      ],
                      stops: [0, 0.4, 0.7, 0.9, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.09,
                  left: 0,
                  right: 0,
                  child: Material(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(color: Color(0xFFA31321)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.04,
                  left: screenWidth * 0.25,
                  right: screenWidth * 0.25,
                  child: Image.asset(
                    'assets/bantayalert_menulogo.png',
                    height: screenHeight * 0.15,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/waiting.json'),
                      SizedBox(
                        height: 16,
                      ), // spacing between animation and text
                      Text(
                        'Waiting to be approved...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
