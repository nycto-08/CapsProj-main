import 'package:bantay_alertdraft/sidebar/my_profile/authority_my_profile.dart';
import 'package:bantay_alertdraft/sidebar/my_profile/resident_my_profile.dart';
import 'package:bantay_alertdraft/sidebar/setting_sidebar/authority_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';

class AuthorityWaitAcceptedSidebar extends StatelessWidget {
  const AuthorityWaitAcceptedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double drawerWidth = screenWidth * 0.8;
    final residentData = Provider.of<ResidentVariable>(context);

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          color: Color(0xFFA31321),
          child: Column(
            children: [
              Container(
                color: Color(0xFF7C0A20),
                width: double.infinity,
                height: 120,
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 25.0,
                  right: 15.0,
                  bottom: 10.0,
                ), // Adjusted top padding
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        residentData.profileImagePath.isNotEmpty
                            ? residentData.profileImagePath
                            : "assets/profile_picture.png",
                      ), // Profile picture
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center content vertically
                      children: [
                        Text(
                          "${residentData.firstNameController.text.isNotEmpty ? residentData.firstNameController.text : "First Name"} ${residentData.lastNameController.text.isNotEmpty ? residentData.lastNameController.text : "Last Name"}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Montserrat",
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              residentData.phoneNumberController.text.isNotEmpty
                                  ? residentData.phoneNumberController.text
                                  : "Phone Number",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            Text(
                              " | ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            Text(
                              "Resident",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        Text(
                          residentData.emailController.text.isNotEmpty
                              ? residentData.emailController.text
                              : "Email Address",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "Montserrat",
                          ),
                          overflow: TextOverflow.ellipsis,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 15.0,
                      ),
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
                              builder: (context) => AuthorityMyProfile(),
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
                              builder: (context) => AuthoritySetting(),
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
                              builder: (context) => ResidentMyProfile(),
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
  Widget _buildMenuItemWithImage(
    String iconPath,
    String title,
    String imagePath,
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return _buildMenuItemBase(
      Image.asset(
        iconPath,
        width: 16,
        height: 16,
        color: Color(0XFFA31321),
      ), // Custom image icon
      title,
      imagePath,
      context,
      onPressed,
    );
  }

  // Base function for menu items
  Widget _buildMenuItemBase(
    Widget iconWidget,
    String title,
    String imagePath,
    BuildContext context,
    VoidCallback onPressed,
  ) {
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
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
            ), // Adjust padding
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
}
