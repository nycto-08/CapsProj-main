import 'package:bantay_alertdraft/sidebar/resident_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart'; 

class ResidentMainPage extends StatelessWidget {
  ResidentMainPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        double buttonSize = screenWidth * 0.38;

        return Scaffold(
          key: _scaffoldKey,
          drawer: ResidentSidebar(),
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
                          icon: Icon(Icons.menu, color: Colors.white, size: 30),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        Spacer(),
                        Consumer<ResidentVariable>(
                          builder: (context, residentVar, child) {
                            int notificationCount = residentVar.notificationCount;
                            return Stack(
                              children: [
                                Icon(Icons.notifications, color: Colors.white, size: 27),
                                if (notificationCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '$notificationCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
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
              Positioned(
                top: screenHeight * 0.22,
                left: 0,
                right: 0,
                child: Center(
                  child: Wrap(
                    spacing: screenWidth * 0.07,
                    runSpacing: screenHeight * 0.03,
                    alignment: WrapAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildEmergencyButton(
                          context, "MEDICAL", 'assets/medical_logo.png', buttonSize, 
                          buttonSize * 0.6, buttonSize * 0.55, 10, 5, () {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildEmergencyButton(
                          context, "AMBULANCE", 'assets/ambulance_logo.png', buttonSize, 
                          buttonSize * 0.90, buttonSize * 0.50, 15, 5, () {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildEmergencyButton(
                          context, "FIRE STATION", 'assets/firestation_logo.png', buttonSize, 
                          buttonSize * 0.6, buttonSize * 0.60, 8, 4, () {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildEmergencyButton(
                          context, "POLICE", 'assets/police_logo.png', buttonSize, 
                          buttonSize * 0.85, buttonSize * 0.55, 16, 2, () {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:_buildEmergencyButton(
                          context, "BARANGAY\nPERSONNEL", 'assets/barangay_logo.png', buttonSize, 
                          buttonSize * 0.55, buttonSize * 0.55, 12, 3, () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, String label, String assetPath, double size, 
    double imageWidth, double imageHeight, double topPadding, double bottomPadding, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA31321),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.zero,
        fixedSize: Size(size, size),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: topPadding),
          ClipRRect(
            child: Image.asset(
              assetPath,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: bottomPadding),
          label == "BARANGAY\nPERSONNEL"
          ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "BARANGAY\n",
                  style: TextStyle(
                    fontSize: size* 0.15,
                    fontFamily: "FranklinGothicHeavy",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE2E2E2),
                    height: 1,
                  )
                ),
                TextSpan(
                  text: "PERSONNEL",
                  style: TextStyle(
                    fontSize: size * 0.10,
                    fontFamily: "FranklinGothicHeavy",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE2E2E2),
                    height: 1,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          )
          : Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.15,
              fontFamily: "FranklinGothicHeavy",
              fontWeight: FontWeight.bold,
              color: Color(0xFFE2E2E2),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
