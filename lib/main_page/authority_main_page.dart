import 'package:bantay_alertdraft/sidebar/authority_sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/sidebar/barangay_sidebar.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';

class AuthorityMainPage extends StatefulWidget {
  const AuthorityMainPage({super.key});

  @override
  _AuthorityMainPage createState() => _AuthorityMainPage();
}

class _AuthorityMainPage extends State<AuthorityMainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<bool> _isBarangayPersonnelFuture;

  @override
  void initState() {
    super.initState();
    _isBarangayPersonnelFuture = _fetchBarangaySwitchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isBarangayPersonnelFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final isBarangayPersonnel = snapshot.data!;
          return PopScope(
            canPop: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;
                double buttonSize = screenWidth * 0.38;

                return Scaffold(
                  key: _scaffoldKey,
                  drawer:
                      isBarangayPersonnel
                          ? BarangaySidebar()
                          : AuthoritySidebar(),
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
                                Spacer(),
                                Consumer<AuthorityVariable>(
                                  builder: (context, authoVar, child) {
                                    int notificationCount =
                                        authoVar.notificationCount;
                                    return Stack(
                                      children: [
                                        Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 27,
                                        ),
                                        if (notificationCount > 0)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                              _buildEmergencyButton(
                                context,
                                "MEDICAL",
                                'assets/medical_logo.png',
                                buttonSize,
                                buttonSize * 0.6,
                                buttonSize * 0.55,
                                10,
                                5,
                                () {},
                              ),
                              _buildEmergencyButton(
                                context,
                                "AMBULANCE",
                                'assets/ambulance_logo.png',
                                buttonSize,
                                buttonSize * 0.90,
                                buttonSize * 0.50,
                                15,
                                5,
                                () {},
                              ),
                              _buildEmergencyButton(
                                context,
                                "FIRE STATION",
                                'assets/firestation_logo.png',
                                buttonSize,
                                buttonSize * 0.6,
                                buttonSize * 0.60,
                                8,
                                4,
                                () {},
                              ),
                              _buildEmergencyButton(
                                context,
                                "POLICE",
                                'assets/police_logo.png',
                                buttonSize,
                                buttonSize * 0.85,
                                buttonSize * 0.55,
                                16,
                                2,
                                () {},
                              ),
                              _buildEmergencyButton(
                                context,
                                "BARANGAY\nPERSONNEL",
                                'assets/barangay_logo.png',
                                buttonSize,
                                buttonSize * 0.55,
                                buttonSize * 0.55,
                                12,
                                3,
                                () {},
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
        } else {
          return const Center(child: Text("Unexpected error."));
        }
      },
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context,
    String label,
    String assetPath,
    double size,
    double imageWidth,
    double imageHeight,
    double topPadding,
    double bottomPadding,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA31321),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                        fontSize: size * 0.15,
                        fontFamily: "FranklinGothicHeavy",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE2E2E2),
                        height: 1,
                      ),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<bool> _fetchBarangaySwitchData() async {
    try {
      final authorityVariable = Provider.of<AuthorityVariable>(
        context,
        listen: false,
      );
      final email = authorityVariable.emailController.text.trim();

      final query =
          await FirebaseFirestore.instance
              .collection('_authorities')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        throw Exception("No matching account found in authority.");
      }

      final authorityData = query.docs.first.data();
      final cityName = authorityData['city'];
      final barangayName = authorityData['barangay'];

      final assignedDocRef =
          await FirebaseFirestore.instance
              .collection("city")
              .doc(cityName)
              .collection("barangay")
              .doc(barangayName)
              .collection("authorities")
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (assignedDocRef.docs.isEmpty) {
        throw Exception('No authorities found for this barangay');
      }

      final assignedDocData = assignedDocRef.docs.first.data();
      return assignedDocData['_barangayPersonnel'] ?? false;
    } catch (e) {
      print('Fetch authority data error: $e');
      return false;
    }
  }
}
