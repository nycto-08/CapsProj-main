import 'package:bantay_alertdraft/sidebar/announcement/authority_announcement.dart';
import 'package:bantay_alertdraft/sidebar/emergency_history/authority_emergency_history.dart';
import 'package:bantay_alertdraft/sidebar/emergency_hotline/emergency_hotline.dart';
import 'package:bantay_alertdraft/sidebar/my_profile/authority_my_profile.dart';
import 'package:bantay_alertdraft/sidebar/setting_sidebar/authority_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';

class AuthoritySidebar extends StatelessWidget {
  const AuthoritySidebar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double drawerWidth = screenWidth * 0.8;
    final authorityData = Provider.of<AuthorityVariable>(context);
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, 
        ),
        child: Container(
          color: Color(0xFFA31321), 
          child: Column(
            children: [
              Container(
                color: Color(0xFF7C0A20), 
                width: double.infinity,
                height: 120, 
                padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 15.0, bottom: 10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(authorityData.profileImagePath.isNotEmpty
                        ? authorityData.profileImagePath
                        : "assets/profile_picture.png"),
                      ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${authorityData.firstNameController.text.isNotEmpty ? authorityData.firstNameController.text : "First Name"} ${authorityData.lastNameController.text.isNotEmpty ? authorityData.lastNameController.text : "Last Name"}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Montserrat",
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          authorityData.phoneNumberController.text.isNotEmpty 
                              ? authorityData.phoneNumberController.text 
                              : "Phone Number",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "Montserrat",
                          ),
                        ),
  
                        Text(
                          "EMPLOYEE NO.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero, // Ensure no extra padding
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                      child: Text(
                        'MENU',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildMenuItemWithImage(
                      "assets/icon_profile.png", 
                      "MY PROFILE", 
                      "assets/sidebar_bg.png", 
                      context,
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AuthorityMyProfile(), 
                            ),
                          );
                        });
                      },
                    ),
                    _buildMenuItemWithImage2(
                      "assets/icon_rphistory.png", 
                      "RESPOND HISTORY", 
                      "assets/sidebar_bg.png", 
                      context,
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AuthorityEmergencyHistory(), 
                            ),
                          );
                        });
                      },
                    ),
                    _buildMenuItemWithImage
                    ("assets/icon_announcement.png", 
                    "ANNOUNCEMENT", 
                    "assets/sidebar_bg.png", 
                    context,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AuthorityAnnouncement(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItemWithImage(
                    "assets/icon_call.png", 
                    "EMERGENCY HOTLINE", 
                    "assets/sidebar_bg.png", 
                    context,
                    () {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 250), () {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EmergencyHotline(), 
                          ),
                        );
                      });
                    },
                    ),
                    _buildMenuItemWithImage(
                      "assets/icon_settings.png", 
                      "SETTINGS", 
                      "assets/sidebar_bg.png", 
                      context,
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AuthoritySetting(), 
                            ),
                          );
                        });
                      },
                    ),
                    _buildMenuItemWithImage(
                      "assets/icon_help.png", 
                      "HELP CENTRE", 
                      "assets/sidebar_bg.png", 
                      context,
                      () {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AuthorityEmergencyHistory(), 
                            ),
                          );
                        });
                      },                   
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function for menu items using custom image icons
  Widget _buildMenuItemWithImage(String iconPath, String title, String imagePath, BuildContext context, VoidCallback onPressed) {
    return _buildMenuItemBase(
      Image.asset(iconPath, width: 16, height: 16, color: Color(0XFFA31321)),
      title,
      imagePath,
      context,
      onPressed,
    );
  }

    // Function for menu items using custom image icons
  Widget _buildMenuItemWithImage2(String iconPath, String title, String imagePath, BuildContext context, VoidCallback onPressed) {
    return _buildMenuItemBase2(
      Image.asset(iconPath, width: 22, height: 22), // Custom image icon
      title,
      imagePath,
      context,
      onPressed,
    );
  }


  // Base function for menu items
  Widget _buildMenuItemBase(Widget iconWidget, String title, String imagePath, BuildContext context, VoidCallback onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Container(
      height: screenHeight * 0.035, 
      width: screenWidth * 0.85,   
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0), // Adjust padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconWidget, // Display either an Image.asset or an Icon
                SizedBox(width: 10), // Space between icon and text
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA31321),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    // Base function for menu items
  Widget _buildMenuItemBase2(Widget iconWidget, String title, String imagePath, BuildContext context, VoidCallback onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Container(
        height: screenHeight * 0.035, 
        width: screenWidth * 0.85,   
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconWidget, 
                SizedBox(width: 10), 
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA31321),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
