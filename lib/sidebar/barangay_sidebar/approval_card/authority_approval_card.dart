import 'dart:io';
import 'package:bantay_alertdraft/instruction_specialpop/iD_instruction/no_image_dialog.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorityApprovalCard extends StatefulWidget {
  const AuthorityApprovalCard({super.key});

  @override
  _AuthorityApprovalCard createState() => _AuthorityApprovalCard();
}

class _AuthorityApprovalCard extends State<AuthorityApprovalCard> {
  
  void _accept(){
    //TO-DO
  }
  
  void _reject(){
    //TO-DO
  }

  @override
  Widget build(BuildContext context) {
    final authoVar = Provider.of<AuthorityVariable>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = (screenWidth - 40) / 2;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: 
          (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: const Color(0xFF7C0A20),
              pinned: false,
              floating: false,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icon_profile.png',
                    color: Colors.white,
                    height: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Authority Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Consumer<AuthorityVariable>(
                builder: (context, authorityVariable, child) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: 
                          authoVar.getProfileImage != null
                            ? FileImage(authoVar.getProfileImage!)
                            : null,
                        child: authoVar.profileImage == null
                          ? Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                          SizedBox(height: 20),
                          headerContainerText(text: "AUTHORITY INFORMATION"),
                          SizedBox(height: 5),
                          customContainer(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 10),
                                Center(
                                  child: headerContainerText(text: "EMPLOYEE NUMBER:", fontSize: 13),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: buildReadTextField(
                                    height: 38,
                                    controller: TextEditingController(text: authoVar.employeeNumber), 
                                    focusNode: authorityVariable.employeeNumberFocusNode, 
                                    labelText: 'Employee Number', 
                                    onTap: () {}, 
                                    onTapOutsideCallback: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),                            
                          SizedBox(height: 10),
                            headerContainerText(text: "My Personal Information"),
                            const SizedBox(height: 5),
                            customContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: headerTextField(text: " Name"),
                                      ),
                                      const SizedBox(width: 262),
                                      Expanded(
                                        flex: 1,
                                        child: headerTextField(text: "Age"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getFirstName), 
                                          focusNode:  authorityVariable.firstNameFocusNode, 
                                          labelText: "First Name", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ), 
                                      ),
                                      const SizedBox(width: 8),
                                      //Last Name
                                      Expanded(
                                        flex: 3,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getLastName), 
                                          focusNode: authorityVariable.lastNameFocusNode, 
                                          labelText: "Last Name", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      //Middle Name
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getMiddleInitial), 
                                          focusNode: authorityVariable.middleInitialFocusNode, 
                                          labelText: "M.I.", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      //Age
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getAge.toString()), 
                                          focusNode: authorityVariable.ageFocusNode, 
                                          labelText: "Age", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: headerTextField(text: " Birthdate"),
                                      ),
                                      const SizedBox(width: 55),
                                      Expanded(
                                        flex: 1,
                                        child: headerTextField(text: "Sex"),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: headerTextField(text: "Civil Status"),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getMonth), 
                                          focusNode: authorityVariable.monthFocusNode, 
                                          labelText: "Month", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 2,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getDay.toString()), 
                                          focusNode: authorityVariable.dayFocusNode, 
                                          labelText: "Day", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 3,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getYear.toString()), 
                                          focusNode: authorityVariable.yearFocusNode, 
                                          labelText: "Year", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getSex), 
                                          focusNode: authorityVariable.sexFocusNode, 
                                          labelText: "Sex", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 5,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getCivilStatus), 
                                          focusNode: authorityVariable.civilStatusFocusNode, 
                                          labelText: "Civil Status", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: headerTextField(text: " Blood Type"),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: headerTextField(text: "Phone Number"),
                                      ),
                                      const SizedBox(width: 165),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getBloodType), 
                                          focusNode: authorityVariable.bloodTypeFocusNode, 
                                          labelText: "Blood Type", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 3,
                                        child: buildPhoneReadTextField(
                                          controller: TextEditingController(text: authoVar.getPhoneNumber), 
                                          focusNode: authorityVariable.phoneNumberFocusNode, 
                                          labelText: "Phone Number", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  headerTextField(text: "Email"),
                                  const SizedBox(height: 5),
                                  buildReadTextField(
                                    width: 375,
                                    controller: TextEditingController(text: authoVar.getEmail), 
                                    focusNode: authorityVariable.emailFocusNode, 
                                    labelText: "Email", 
                                    onTap: () {},
                                    onTapOutsideCallback: () {},
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            headerContainerText(text: "My Personal Address"),
                            const SizedBox(height: 5),
                            customContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getHouseBlock), 
                                          focusNode: authorityVariable.houseBlockFocusNode, 
                                          labelText: "House Block and Street", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getCityProvince), 
                                          focusNode: authorityVariable.cityProvinceFocusNode, 
                                          labelText: "City/Province", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getBarangay), 
                                          focusNode: authorityVariable.barangayFocusNode, 
                                          labelText: "Barangay", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            headerContainerText(text: "Emergency Contact Information"),
                            const SizedBox(height: 5),
                            customContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headerTextField(text: "Name"),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getNameEmergency), 
                                          focusNode: authorityVariable.nameEmergencyFocusNode, 
                                          labelText: "First Name", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 3,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getLastEmergency), 
                                          focusNode: authorityVariable.lastEmergencyFocusNode, 
                                          labelText: "Last Name", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getMiddleEmergency), 
                                          focusNode: authorityVariable.middleEmergencyFocusNode, 
                                          labelText: "M.I.", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: headerTextField(text: "Relationship"),
                                      ),
                                      Expanded(
                                        flex: 1,                                    
                                        child: headerTextField(text: "Phone Number"),
                                      ),
                                      const SizedBox(width: 165),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getRelationshipEmergency), 
                                          focusNode: authorityVariable.relationshipEmergencyFocusNode, 
                                          labelText: "Relationship", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 3,
                                        child: buildPhoneReadTextField(
                                          controller: TextEditingController(text: authoVar.getPhoneNumberEmergency), 
                                          focusNode: authorityVariable.phoneNumberEmergencyFocusNode, 
                                          labelText: "Phone Number", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
                            const SizedBox(height: 10),
                            headerContainerText(text: "Emergency Contact Address"),
                            const SizedBox(height: 5),
                            customContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getHouseBlockEmergency), 
                                          focusNode: authorityVariable.houseBlockEmergencyFocusNode, 
                                          labelText: "House Block and Street", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.getCityProvinceEmergency), 
                                          focusNode: authorityVariable.cityProvinceEmergencyFocusNode, 
                                          labelText: "City/Province", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: buildReadTextField(
                                          controller: TextEditingController(text: authoVar.barangayEmergency), 
                                          focusNode: authorityVariable.barangayEmergencyFocusNode, 
                                          labelText: "Barangay", 
                                          onTap: () {}, 
                                          onTapOutsideCallback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              customImageContainer(
                width: 395,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    headerContainerText(text: "SUBMITTED ID"),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<AuthorityVariable>(
                          builder: (context, authorityVariable, child) {
                            return submitImageDisplay(
                              context: context, 
                              label: "ID PICTURE\n(FRONT)", 
                              imagePath: authoVar.idFrontImagePath, 
                              size: buttonSize, 
                              assetPath: "assets/frontID.png", 
                              showNoImageDialog: showNoImageDialog,
                            );
                          },
                        ),
                        SizedBox(width: 5),
                        Consumer <AuthorityVariable>(
                          builder: (context, authorityVariable, child) {
                            return submitImageDisplay(
                              context: context, 
                              label: "ID PICTURE\n(BACK)", 
                              imagePath: authoVar.idBackImagePath, 
                              size: buttonSize, 
                              assetPath: "assets/backID.png", 
                              showNoImageDialog: showNoImageDialog,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              roleContainer(
                width: 395,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    roleHeaderContainerText(text: "EMERGENCY RESPONSE TYPE"),
                    const SizedBox(height: 15),
                    Consumer <AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        return roleCardSwitch(
                          assetPath: 'assets/medical_logo.png', 
                          label: 'MEDICAL',
                          switchValue: authorityVariable.medicalSwitch,
                          onSwitchChanged: (value) {
                            setState(() {
                              authorityVariable.setMedicalSwitch(value);
                            });
                          }
                        ); 
                      },
                    ),
                    const SizedBox(height: 5),
                    Consumer <AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        return roleCardSwitch(
                          assetPath: 'assets/ambulance_logo.png', 
                          label: 'AMBULANCE',
                          switchValue: authorityVariable.ambulanceSwitch,
                          onSwitchChanged: (value) {
                            setState(() {
                              authorityVariable.setAmbulanceSwitch(value);
                            });
                          }
                        ); 
                      },
                    ),
                    const SizedBox(height: 5),
                    Consumer <AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        return roleCardSwitch(
                          assetPath: 'assets/firestation_logo.png', 
                          label: 'FIRE STATION',
                          switchValue: authorityVariable.fireStationSwitch,
                          onSwitchChanged: (value) {
                            setState(() {
                              authorityVariable.setFireStationSwitch(value);
                            });
                          }
                        ); 
                      },
                    ),
                    const SizedBox(height: 5),
                    Consumer <AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        return roleCardSwitch(
                          assetPath: 'assets/police_logo.png', 
                          label: 'POLICE',
                          switchValue: authorityVariable.fireStationSwitch,
                          onSwitchChanged: (value) {
                            setState(() {
                              authorityVariable.setFireStationSwitch(value);
                            });
                          }
                        ); 
                      },
                    ),
                    const SizedBox(height: 5),
                    Consumer <AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        return roleCardSwitch(
                          assetPath: 'assets/barangay_logo.png', 
                          label: 'BARANGAY\nPERSONNEL',
                          switchValue: authorityVariable.fireStationSwitch,
                          onSwitchChanged: (value) {
                            setState(() {
                              authorityVariable.setFireStationSwitch(value);
                            });
                          }
                        ); 
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const SizedBox(width: 10),
                   ElevatedButton(
                    onPressed: _reject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF0000),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ), 
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "REJECT",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat-Extrabold',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _accept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A651),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "ACCEPT",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat-ExtraBold',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                   ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget headerContainerText({
  required String text,
  Color color = const Color(0xFF7C0A20),
  double fontSize = 15,
  String fontFamily = 'RobotoMedium',
  FontWeight fontWeight = FontWeight.bold,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget customContainer({
    required Widget child,
    double width = 395,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    Color color = Colors.transparent,
    double borderRadius = 10.0,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  Widget customImageContainer({
    required Widget child,
    double width = 395,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    Color color = const Color(0xFFDBDBDB),
    double borderRadius = 10.0,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  Widget roleContainer({
    required Widget child,
    double width = 395,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    Color color = const Color(0xFFDBDBDB),
    double borderRadius = 10.0,
    Color borderColor = const Color(0xFF7C0A20),
    double borderWidth = 5.0,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }

  Widget roleSpecificContainer({
    required Widget child, 
    double width = 325,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    Color color = const Color(0xFFBCBEC0),
    double borderRadius = 10.0,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  Icon? thumbIcon(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.check, color: Colors.white, size: 18);
    }
    return const Icon(Icons.close, color: Colors.white, size: 18);
  }

  Color thumbColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.black;
    }
    return Colors.red;
  }

  Widget roleCardSwitch({
    required String assetPath,
    required String label,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
  }) {
    return customContainer(
      width: 345,
      color: const Color(0xFFBCBEC0),
      borderRadius: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF7C0A20),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF7C0A20),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          Spacer(), // pushes the switch to the right
          SwitchTheme(
            data: SwitchThemeData(
              thumbIcon: WidgetStateProperty.resolveWith(thumbIcon),
              thumbColor: WidgetStateProperty.resolveWith(thumbColor),
            ),
            child: Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }


  Widget roleHeaderContainerText({
  required String text,
  double width = double.infinity,
  double height = 30,
  Color textColor = Colors.white,
  Color backgroundColor = const Color(0xFF7C0A20),
  double fontSize = 15,
  String fontFamily = 'RobotoMedium',
  double borderRadius = 30.0,
  FontWeight fontWeight = FontWeight.bold,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget headerTextField({
    required String text,
    Color color = Colors.black,
    double fontSize = 14,
    String fontFamily = 'RobotoRegular',
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget buildReadTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    double width = 120,
    double height = 52,
  }) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.selection = const TextSelection.collapsed(offset: 0);
      }
    });
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.none,
          readOnly: true,
          showCursor: true, 
          enableInteractiveSelection: true, 
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: Color(0xFF8A8C8E),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
            overflow: TextOverflow.ellipsis,
          ),
          decoration: customReadDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
          onTap: () {
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          scrollPadding: const EdgeInsets.all(0),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget buildPhoneReadTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    double width = 120,
    double height = 52,
  }) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.selection = const TextSelection.collapsed(offset: 0);
      }
    });
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          showCursor: true, 
          enableInteractiveSelection: true, 
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: Color(0xFF8A8C8E),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
            overflow: TextOverflow.ellipsis,
          ),
          decoration: customReadDecoration(
            labelText: labelText,
            focusNode: focusNode,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '+63',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          onTap: () {
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          scrollPadding: const EdgeInsets.all(0),
          maxLines: 1,
          keyboardType: TextInputType.none,
        ),
      ),
    );
  }

  InputDecoration customReadDecoration({
    required String labelText,
    required FocusNode focusNode,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      label: RichText(
        text: TextSpan(
          text: labelText,
          style: TextStyle(
            color: focusNode.hasFocus ? Color(0xFFA31321) : Color(0xFF9E9E9E),
            overflow: TextOverflow.ellipsis, 
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFF9E9E9E), width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFA31321), width: 3),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
    );
  }


  Widget submitImageDisplay({
    required BuildContext context,
    required String label,
    required String imagePath,
    required double size,
    required String assetPath,
    required Future<void> Function(BuildContext context) showNoImageDialog,
  }) {
    return SizedBox(
      width: size * 0.85,
      height: size * 0.85,
      child: ElevatedButton(
        onPressed: () async {
          if (imagePath.isEmpty || !File(imagePath).existsSync()) {
            await showNoImageDialog(context);
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imagePath),
                          width: size * 0.75,
                          height: size * 0.6,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA31321),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white),
          ),
          padding: const EdgeInsets.all(6),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  assetPath,
                  width: size * 0.45,
                  height: size * 0.28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size * 0.09,
                  fontFamily: 'FranklinGothicHeavy',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
