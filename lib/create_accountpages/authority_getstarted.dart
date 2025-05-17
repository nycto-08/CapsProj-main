import 'dart:io';
import 'dart:math' as math;
import 'package:bantay_alertdraft/instruction_specialpop/logout_confirmation/logoutdialogbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:bantay_alertdraft/instruction_specialpop/iD_instruction/front_back_id.dart';
import 'package:bantay_alertdraft/instruction_specialpop/authority_submit/authority_success_submit.dart';

class AuthorityGetStartedPage extends StatefulWidget {
  const AuthorityGetStartedPage({super.key});

  @override
  _AuthorityGetStartedPage createState() => _AuthorityGetStartedPage();
}

class _AuthorityGetStartedPage extends State<AuthorityGetStartedPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfileData();
      Provider.of<AuthorityVariable>(
        context,
        listen: false,
      ).initializeCityBarangay();
    });
  }

  void _done() async {
    FocusScope.of(context).unfocus();

    final authoVar = Provider.of<AuthorityVariable>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      try {
        String cityName = authoVar.selectedCityProvince;
        String barangayName = authoVar.selectedBarangay;
        final employeeNumber = authoVar.employeeNumberController.text.trim();
        final email = authoVar.newEmailController.text.trim();

        final emailQuery =
            await FirebaseFirestore.instance
                .collection('_authorities')
                .where('email', isEqualTo: email)
                .limit(1)
                .get();

        if (emailQuery.docs.isEmpty) {
          throw Exception("No matching account found in authority.");
        }

        final emailDocId = emailQuery.docs.first.id;
        final authorityQuery =
            await FirebaseFirestore.instance
                .collection('city')
                .doc(cityName)
                .collection('barangay')
                .doc(barangayName)
                .collection('authorities')
                .where('employeeNumber', isEqualTo: employeeNumber)
                .limit(1)
                .get();

        if (authorityQuery.docs.isEmpty) {
          // Focus on the employee number field
          authoVar.employeeNumberController.clear();
          authoVar.employeeNumberFocusNode.requestFocus();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No authority found with this employee number.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return; // Stop execution
        }

        final authorityDocId = authorityQuery.docs.first.id;
        final authorityDB = authorityQuery.docs.first.data();

        if (authorityDB.containsKey('email') &&
            authorityDB['email'] != null &&
            (authorityDB['email'] as String).isNotEmpty) {
          throw Exception(
            'This employee number is already assigned to an email.',
          );
        }
        final authorityData = {
          //EmployeeNumber
          'employeeNumber': employeeNumber,
          //Personal Info
          'firstName': authoVar.firstNameController.text.trim(),
          'lastName': authoVar.lastNameController.text.trim(),
          'middleInitial': authoVar.middleInitController.text.trim(),
          'age': authoVar.selectedAge,
          'birthMonth': authoVar.monthController.text.trim(),
          'birthDay': authoVar.dayController.text.trim(),
          'birthYear': authoVar.yearController.text.trim(),
          'sex': authoVar.sexController.text.trim(),
          'civilStatus': authoVar.selectedCivilStatus,
          'bloodType': authoVar.selectedBloodType,
          'contactNumber': authoVar.phoneNumberController.text.trim(),
          'email': email,
          //Personal Address
          'houseBlock': authoVar.houseBlockController.text.trim(),
          'city': cityName,
          'barangay': barangayName,
          //Emergency Contact
          'emergencyFirstName': authoVar.nameEmergencyController.text.trim(),
          'emergencyLastName': authoVar.lastEmergencyController.text.trim(),
          'emergencyMiddleInitial': authoVar.middleInitController.text.trim(),
          'emergencyRelationship': authoVar.selectedRelationship,
          'emergencyPhoneNumber':
              authoVar.phoneNumberEmergencyController.text.trim(),
          //Emergency Contact Address
          'emergencyHouseBlock':
              authoVar.houseBlockEmergencyController.text.trim(),
          'emergencyCity': authoVar.cityProvinceEmergencyController.text.trim(),
          'emergencyBarangay': authoVar.barangayEmergencyController.text.trim(),
          '_medical': authoVar.medicalSwitch,
          '_ambulance': authoVar.ambulanceSwitch,
          '_fireStation': authoVar.fireStationSwitch,
          '_police': authoVar.policeSwitch,
          '_barangayPersonnel': authoVar.barangayPersonnelSwitch,
          'approved': false,
        };

        await FirebaseFirestore.instance
            .collection('city')
            .doc(cityName)
            .collection('barangay')
            .doc(barangayName)
            .collection('authorities')
            .doc(authorityDocId)
            .set(authorityData);

        await FirebaseFirestore.instance
            .collection('_authorities')
            .doc(emailDocId)
            .update({
              'city': cityName,
              'barangay': barangayName,
              'assigned': true,
            });

        if (mounted) {
          showAuthoritySuccessDialog(context);
        }
      } catch (e) {
        debugPrint('Error saving data: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = (screenWidth - 40) / 2;

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () {
                        showAuthorityGetStartedLogoutDialog(context);
                      },
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ),
                    title: Text(
                      'Get Started (Authority Account)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: const Color(0xFF7C0A20),
                    centerTitle: true,
                    pinned: false,
                    floating: false,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),
                        onPressed: () {
                          //TO-DO
                        },
                      ),
                    ],
                  ),
                ],
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFEFEDED),
                        Color(0xFFE2ACB0),
                        Color(0xFFD88990),
                      ],
                      stops: [0, 0.4, 0.9, 1.0],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Consumer<AuthorityVariable>(
                          builder: (context, authorityVariable, child) {
                            //var_Data
                            final List<int> ageList = List.generate(
                              100,
                              (index) => index,
                            ); // Generates 0..99
                            return Column(
                              children: [
                                SizedBox(height: 20),
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage:
                                      authorityVariable.profileImage != null
                                          ? FileImage(
                                            authorityVariable.profileImage!,
                                          )
                                          : null,
                                  child:
                                      authorityVariable.profileImage == null
                                          ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          )
                                          : null,
                                ),
                                SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _showImagePicker(
                                      context,
                                      authorityVariable,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: Text(
                                    "Upload a Picture",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7C0A20),
                                    minimumSize: Size(150, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 20),
                                      customContainer(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10),
                                            Center(
                                              child: headerContainerField(
                                                text: "EMPLOYEE NUMBER:",
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              flex: 1,
                                              child: buildTextField(
                                                height: 38,
                                                controller:
                                                    authorityVariable
                                                        .employeeNumberController,
                                                focusNode:
                                                    authorityVariable
                                                        .employeeNumberFocusNode,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                labelText: 'Employee Number',
                                                onTap: () {},
                                                onTapOutsideCallback: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      customContainer(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: headerContainerField(
                                                text: "My Personal Information",
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            //NAME
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: headerTextField(
                                                    text: "Name",
                                                  ),
                                                ),
                                                const SizedBox(width: 215),
                                                Expanded(
                                                  flex: 1,
                                                  child: headerTextField(
                                                    text: "Age",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //NAME && AGE FIELDS
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                //FIRST NAME
                                                Expanded(
                                                  flex: 2,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .firstNameController,
                                                    focusNode:
                                                        authorityVariable
                                                            .firstNameFocusNode,
                                                    labelText: "First Name",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //LAST NAME
                                                Expanded(
                                                  flex: 2,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .lastNameController,
                                                    focusNode:
                                                        authorityVariable
                                                            .lastNameFocusNode,
                                                    labelText: "Last Name",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                //MIDDLE INTIAL
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .middleInitController,
                                                    focusNode:
                                                        authorityVariable
                                                            .middleInitialFocusNode,
                                                    labelText: "M.I.",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //AGE
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      buildIntDropdownTextField(
                                                        focusNode:
                                                            authorityVariable
                                                                .ageFocusNode,
                                                        value:
                                                            authorityVariable
                                                                .selectedAge,
                                                        items: ageList,
                                                        labelText: "Age",
                                                        onChanged: (
                                                          int? ageValue,
                                                        ) {
                                                          authorityVariable
                                                                  .selectedAge =
                                                              ageValue;
                                                        },
                                                        onTapOutsideCallback:
                                                            () {},
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: headerTextField(
                                                    text: "Birthdate",
                                                  ),
                                                ),
                                                const SizedBox(width: 60),
                                                Expanded(
                                                  flex: 1,
                                                  child: headerTextField(
                                                    text: "Sex",
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 2,
                                                  child: headerTextField(
                                                    text: "Civil Status",
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            //BIRTHDAY && SEX && AGE
                                            Row(
                                              children: [
                                                //MONTH
                                                Expanded(
                                                  flex: 3,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .monthController,
                                                    focusNode:
                                                        authorityVariable
                                                            .monthFocusNode,
                                                    labelText: "Month",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                //DAY
                                                Expanded(
                                                  flex: 2,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .dayController,
                                                    focusNode:
                                                        authorityVariable
                                                            .dayFocusNode,
                                                    labelText: "Day",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //YEAR
                                                Expanded(
                                                  flex: 2,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .yearController,
                                                    focusNode:
                                                        authorityVariable
                                                            .yearFocusNode,
                                                    labelText: "Year",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //SEX
                                                Expanded(
                                                  flex: 2,
                                                  child: buildReadTextField(
                                                    controller:
                                                        authorityVariable
                                                            .sexController,
                                                    focusNode:
                                                        authorityVariable
                                                            .sexFocusNode,
                                                    labelText: "Sex",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 4,
                                                  child: buildStringDropdownTextField(
                                                    focusNode:
                                                        authorityVariable
                                                            .civilStatusFocusNode,
                                                    value:
                                                        authorityVariable
                                                            .selectedCivilStatus,
                                                    items: [
                                                      "Single",
                                                      "Married",
                                                      "Widowed",
                                                      "Separated",
                                                      "Civil Union",
                                                    ],
                                                    labelText: "Civil Status",
                                                    onChanged: (
                                                      String? newCivilStatus,
                                                    ) {
                                                      if (newCivilStatus !=
                                                          null) {
                                                        authorityVariable
                                                            .setSelectedCivilStatus(
                                                              newCivilStatus,
                                                            );
                                                      }
                                                    },
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
                                                  child: headerTextField(
                                                    text: " Blood Type",
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: headerTextField(
                                                    text: "Phone Number",
                                                  ),
                                                ),
                                                const SizedBox(width: 145),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                //BLOOD TYPE
                                                Expanded(
                                                  flex: 2,
                                                  child: buildStringDropdownTextField(
                                                    focusNode:
                                                        authorityVariable
                                                            .bloodTypeFocusNode,
                                                    value:
                                                        authorityVariable
                                                            .selectedBloodType,
                                                    items: [
                                                      'A+',
                                                      'A-',
                                                      'B+',
                                                      'B-',
                                                      'AB+',
                                                      'AB-',
                                                      'O+',
                                                      'O-',
                                                      'Unknown',
                                                    ],
                                                    labelText: 'Blood Type',
                                                    onChanged: (
                                                      String? newBloodType,
                                                    ) {
                                                      if (newBloodType !=
                                                          null) {
                                                        authorityVariable
                                                            .setSelectedBloodType(
                                                              newBloodType,
                                                            );
                                                      }
                                                    },
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //PHONE NUMBER
                                                Expanded(
                                                  flex: 5,
                                                  child: buildPhoneTextField(
                                                    controller:
                                                        authorityVariable
                                                            .phoneNumberController,
                                                    focusNode:
                                                        authorityVariable
                                                            .phoneNumberFocusNode,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                        10,
                                                      ),
                                                    ],
                                                    labelText: 'Phone Number',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return 'This field cannot be empty.';
                                                      }
                                                      final phone =
                                                          value.trim();
                                                      final regExp = RegExp(
                                                        r'^(9\d{9})$',
                                                      );

                                                      if (!regExp.hasMatch(
                                                        phone,
                                                      )) {
                                                        return 'Enter a valid phone number.';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            headerTextField(
                                              text: "Email Address",
                                            ),
                                            const SizedBox(height: 5),
                                            //EMAIL
                                            buildReadTextField(
                                              width: 375,
                                              controller:
                                                  authorityVariable
                                                      .newEmailController,
                                              focusNode:
                                                  authorityVariable
                                                      .emailFocusNode,
                                              labelText: "Email",
                                              onTap: () {},
                                              onTapOutsideCallback: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      customContainer(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: headerContainerField(
                                                text: 'Personal Address',
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                //HOUSE BLOCK AND STREET
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .houseBlockController,
                                                    focusNode:
                                                        authorityVariable
                                                            .houseBlockFocusNode,
                                                    labelText:
                                                        "House Block and Street",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildStringDropdownTextField(
                                                    focusNode:
                                                        authorityVariable
                                                            .cityProvinceFocusNode,
                                                    value:
                                                        authorityVariable
                                                            .selectedCityProvince,
                                                    items:
                                                        authorityVariable
                                                            .cityToBarangayMap
                                                            .keys
                                                            .toList(),
                                                    labelText: "City/Province",
                                                    onChanged: (
                                                      String? newCityProvince,
                                                    ) {
                                                      if (newCityProvince !=
                                                          null) {
                                                        authorityVariable
                                                            .setSelectedCityProvince(
                                                              newCityProvince,
                                                            );
                                                      }
                                                    },
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //BARANGAY
                                                Expanded(
                                                  flex: 1,
                                                  child: buildStringDropdownTextField(
                                                    focusNode:
                                                        authorityVariable
                                                            .barangayFocusNode,
                                                    value:
                                                        authorityVariable
                                                            .selectedBarangay,
                                                    items:
                                                        authorityVariable
                                                            .availableBarangays,
                                                    labelText: "Barangay",
                                                    onChanged: (
                                                      String? newBarangay,
                                                    ) {
                                                      if (newBarangay != null) {
                                                        authorityVariable
                                                            .setSelectedBarangay(
                                                              newBarangay,
                                                            );
                                                      }
                                                    },
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      customContainer(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //EMERGENCY CONTACT INFORMATION
                                            Center(
                                              child: headerContainerField(
                                                text:
                                                    'Emergency Contact Information',
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            headerTextField(text: 'Name'),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                //EMERGENCY NAME
                                                Expanded(
                                                  flex: 2,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .nameEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .nameEmergencyFocusNode,
                                                    labelText: 'First Name',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //ENERGENCY LAST NAME
                                                Expanded(
                                                  flex: 2,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .lastEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .lastEmergencyFocusNode,
                                                    labelText: 'Last Name',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //EMERGENCY MIDDLE CONTROLLER
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .middleEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .middleEmergencyFocusNode,
                                                    labelText: 'M.I.',
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
                                                  child: headerTextField(
                                                    text: 'Relationship',
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: headerTextField(
                                                    text: 'Phone Number',
                                                  ),
                                                ),
                                                const SizedBox(width: 115),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                //RELATIONSHIP EMERGENCY
                                                Expanded(
                                                  flex: 2,
                                                  child: buildStringDropdownTextField(
                                                    focusNode:
                                                        authorityVariable
                                                            .relationshipEmergencyFocusNode,
                                                    value:
                                                        authorityVariable
                                                            .selectedRelationship,
                                                    items: [
                                                      'Parent',
                                                      'Guardian',
                                                      'Sibling',
                                                      'Child',
                                                      'Spouse',
                                                      'Friend/Acquaintance',
                                                    ],
                                                    labelText: 'Relationship',
                                                    onChanged: (
                                                      String? newRelationship,
                                                    ) {
                                                      if (newRelationship !=
                                                          null) {
                                                        authorityVariable
                                                            .setSelectedRelationship(
                                                              newRelationship,
                                                            );
                                                      }
                                                    },
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 4,
                                                  child: buildPhoneTextField(
                                                    controller:
                                                        authorityVariable
                                                            .phoneNumberEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .phoneNumberEmergencyFocusNode,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                        10,
                                                      ),
                                                    ],
                                                    labelText: 'Phone Number',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return 'This field cannot be empty.';
                                                      }
                                                      final phone =
                                                          value.trim();
                                                      final regExp = RegExp(
                                                        r'^(9\d{9})$',
                                                      );

                                                      if (!regExp.hasMatch(
                                                        phone,
                                                      )) {
                                                        return 'Enter a valid phone number.';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      customContainer(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: headerContainerField(
                                                text:
                                                    'Emergency Contact Address',
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .houseBlockEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .houseBlockEmergencyFocusNode,
                                                    labelText:
                                                        'House Block and Street',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .cityProvinceEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .cityProvinceEmergencyFocusNode,
                                                    labelText: 'City/Province',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        authorityVariable
                                                            .barangayEmergencyController,
                                                    focusNode:
                                                        authorityVariable
                                                            .barangayEmergencyFocusNode,
                                                    labelText: 'Barangay',
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
                        Container(
                          width: 395,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDBDBDB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              headerContainerField(text: "UPLOAD VALID ID"),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Use Consumer ONLY for the ID Front Image Path
                                  Consumer<AuthorityVariable>(
                                    builder: (
                                      context,
                                      authorityVariable,
                                      child,
                                    ) {
                                      return Expanded(
                                        flex: 1,
                                        child: _iDUploadButton(
                                          context,
                                          authorityVariable.idFrontImagePath,
                                          "ID PICTURE\n(FRONT)",
                                          'assets/frontID.png',
                                          buttonSize,
                                          screenWidth,
                                          () => _showFrontIDPicker(
                                            context,
                                            authorityVariable,
                                          ),
                                          () => authorityVariable
                                              .setidFrontImagePath(null),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Consumer<AuthorityVariable>(
                                      builder: (
                                        context,
                                        authorityVariable,
                                        child,
                                      ) {
                                        return _iDUploadButton(
                                          context,
                                          authorityVariable.idBackImagePath,
                                          "ID PICTURE\n(BACK)",
                                          'assets/backID.png',
                                          buttonSize,
                                          screenWidth,
                                          () => _showBackIDPicker(
                                            context,
                                            authorityVariable,
                                          ),
                                          () => authorityVariable
                                              .setidBackImagePath(null),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        customContainer(
                          color: const Color(0xFFDBDBDB),
                          borderColor: const Color(0xFF7C0A20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          borderWidth: 5.0,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              roleHeaderContainerText(
                                text: "EMERGENCY RESPONSE TYPE",
                              ),
                              const SizedBox(height: 15),

                              // MEDICAL
                              Consumer<AuthorityVariable>(
                                builder: (context, authorityVariable, child) {
                                  return roleCardSwitch(
                                    assetPath: 'assets/medical_logo.png',
                                    label: 'MEDICAL',
                                    switchValue:
                                        authorityVariable.medicalSwitch,
                                    onSwitchChanged:
                                        authorityVariable.setMedicalSwitch,
                                  );
                                },
                              ),
                              const SizedBox(height: 5),

                              // AMBULANCE
                              Consumer<AuthorityVariable>(
                                builder: (context, authorityVariable, child) {
                                  return roleCardSwitch(
                                    assetPath: 'assets/ambulance_logo.png',
                                    label: 'AMBULANCE',
                                    switchValue:
                                        authorityVariable.ambulanceSwitch,
                                    onSwitchChanged:
                                        authorityVariable.setAmbulanceSwitch,
                                  );
                                },
                              ),
                              const SizedBox(height: 5),

                              // FIRE STATION
                              Consumer<AuthorityVariable>(
                                builder: (context, authorityVariable, child) {
                                  return roleCardSwitch(
                                    assetPath: 'assets/firestation_logo.png',
                                    label: 'FIRE STATION',
                                    switchValue:
                                        authorityVariable.fireStationSwitch,
                                    onSwitchChanged:
                                        authorityVariable.setFireStationSwitch,
                                  );
                                },
                              ),
                              const SizedBox(height: 5),

                              // POLICE
                              Consumer<AuthorityVariable>(
                                builder: (context, authorityVariable, child) {
                                  return roleCardSwitch(
                                    assetPath: 'assets/police_logo.png',
                                    label: 'POLICE',
                                    switchValue: authorityVariable.policeSwitch,
                                    onSwitchChanged:
                                        authorityVariable.setPoliceSwitch,
                                  );
                                },
                              ),
                              const SizedBox(height: 5),

                              // BARANGAY PERSONNEL
                              Consumer<AuthorityVariable>(
                                builder: (context, authorityVariable, child) {
                                  return roleCardSwitch(
                                    assetPath: 'assets/barangay_logo.png',
                                    label: 'BARANGAY\nPERSONNEL',
                                    switchValue:
                                        authorityVariable
                                            .barangayPersonnelSwitch,
                                    onSwitchChanged:
                                        authorityVariable.setBarangaySwitch,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _done,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFA31321),
                            padding: EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 16,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat-ExtraBold',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //PROFILE IMAGEPICKER FUNCTION
  Future<void> _showImagePicker(
    BuildContext context,
    AuthorityVariable authorityVariable,
  ) async {
    if (!context.mounted) return;

    PermissionStatus cameraPermission = await Permission.camera.request();
    PermissionStatus galleryPermission;

    // Use Permission.photos for both Android & iOS
    if (Platform.isIOS || Platform.isAndroid) {
      galleryPermission = await Permission.photos.request();
    } else {
      galleryPermission =
          PermissionStatus.granted; // Default for unsupported platforms
    }

    if (!cameraPermission.isGranted && !galleryPermission.isGranted) {
      if (!context.mounted) return;
      bool retry = await _showPermissionDeniedDialog(context);
      if (retry) {
        return _showImagePicker(context, authorityVariable);
      }
      return;
    }

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color:
                      cameraPermission.isGranted
                          ? Color(0xFF7C0A20)
                          : Colors.grey,
                ),
                title: Text(
                  'Take a Picture',
                  style: TextStyle(
                    color:
                        cameraPermission.isGranted
                            ? Color(0xFF7C0A20)
                            : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enabled: cameraPermission.isGranted,
                onTap:
                    cameraPermission.isGranted
                        ? () async {
                          Navigator.pop(context);
                          final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1024,
                            maxHeight: 1024,
                            imageQuality: 85,
                          );
                          if (image != null) {
                            authorityVariable.setProfileImage(image);
                          }
                        }
                        : null,
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color:
                      galleryPermission.isGranted ? Colors.black : Colors.grey,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        galleryPermission.isGranted
                            ? Colors.black
                            : Colors.grey,
                  ),
                ),
                enabled: galleryPermission.isGranted,
                onTap:
                    galleryPermission.isGranted
                        ? () async {
                          Navigator.pop(context);
                          final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 1024,
                            maxHeight: 1024,
                            imageQuality: 85,
                          );
                          if (image != null) {
                            authorityVariable.setProfileImage(image);
                          }
                        }
                        : null,
              ),
            ],
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  //FRONT ID PICKER
  Future<void> _showFrontIDPicker(
    BuildContext context,
    AuthorityVariable authorityVariable,
  ) async {
    if (!context.mounted) return;

    PermissionStatus cameraPermission = await Permission.camera.request();
    PermissionStatus galleryPermission;

    // Use Permission.photos for both Android & iOS
    if (Platform.isIOS || Platform.isAndroid) {
      galleryPermission = await Permission.photos.request();
    } else {
      galleryPermission =
          PermissionStatus.granted; // Default for unsupported platforms
    }

    if (!cameraPermission.isGranted && !galleryPermission.isGranted) {
      if (!context.mounted) return;
      bool retry = await _showPermissionDeniedDialog(context);
      if (retry) {
        return _showFrontIDPicker(context, authorityVariable);
      }
      return;
    }

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color:
                      cameraPermission.isGranted
                          ? Color(0xFF7C0A20)
                          : Colors.grey,
                ),
                title: Text(
                  'Take a Picture',
                  style: TextStyle(
                    color:
                        cameraPermission.isGranted
                            ? Color(0xFF7C0A20)
                            : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enabled: cameraPermission.isGranted,
                onTap:
                    cameraPermission.isGranted
                        ? () async {
                          Navigator.pop(context);
                          final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            authorityVariable.setidFrontImagePath(image);
                          }
                        }
                        : null,
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color:
                      galleryPermission.isGranted ? Colors.black : Colors.grey,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        galleryPermission.isGranted
                            ? Colors.black
                            : Colors.grey,
                  ),
                ),
                enabled: galleryPermission.isGranted,
                onTap:
                    galleryPermission.isGranted
                        ? () async {
                          Navigator.pop(context);
                          final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            authorityVariable.setidFrontImagePath(image);
                          }
                        }
                        : null,
              ),
            ],
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  //BACK ID PICKER
  Future<void> _showBackIDPicker(
    BuildContext context,
    AuthorityVariable authorityVariable,
  ) async {
    if (!context.mounted) return;

    PermissionStatus cameraPermission = await Permission.camera.request();
    PermissionStatus galleryPermission;

    // Use Permission.photos for both Android & iOS
    if (Platform.isIOS || Platform.isAndroid) {
      galleryPermission = await Permission.photos.request();
    } else {
      galleryPermission =
          PermissionStatus.granted; // Default for unsupported platforms
    }

    if (!cameraPermission.isGranted && !galleryPermission.isGranted) {
      if (!context.mounted) return;
      bool retry = await _showPermissionDeniedDialog(context);
      if (retry) {
        return _showBackIDPicker(context, authorityVariable);
      }
      return;
    }

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color:
                      cameraPermission.isGranted
                          ? Color(0xFF7C0A20)
                          : Colors.grey,
                ),
                title: Text(
                  'Take a Picture',
                  style: TextStyle(
                    color:
                        cameraPermission.isGranted
                            ? Color(0xFF7C0A20)
                            : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enabled: cameraPermission.isGranted,
                onTap:
                    cameraPermission.isGranted
                        ? () async {
                          Navigator.pop(context);
                          final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            authorityVariable.setidBackImagePath(image);
                          }
                        }
                        : null,
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color:
                      galleryPermission.isGranted ? Colors.black : Colors.grey,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        galleryPermission.isGranted
                            ? Colors.black
                            : Colors.grey,
                  ),
                ),
                enabled: galleryPermission.isGranted,
                onTap:
                    galleryPermission.isGranted
                        ? () async {
                          Navigator.pop(context);
                          final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            authorityVariable.setidBackImagePath(image);
                          }
                        }
                        : null,
              ),
            ],
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  // ImageButton Layout
  Widget _iDUploadButton(
    BuildContext context,
    String imagePath,
    String label,
    String assetPath,
    double size,
    double screenWidth,
    VoidCallback onPressed,
    VoidCallback onClear,
  ) {
    return SizedBox(
      width: size * 0.85,
      height: size * 0.85,
      child: ElevatedButton(
        onPressed:
            imagePath.isEmpty && label == "ID PICTURE\n(FRONT)"
                ? () async {
                  bool confirmed = await showFrontCustomDialog(context);
                  if (confirmed) {
                    onPressed();
                  }
                }
                : imagePath.isEmpty && label == "ID PICTURE\n(BACK)"
                ? () async {
                  bool confirmed = await showBackCustomDialog(context);
                  if (confirmed) {
                    onPressed();
                  }
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA31321),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(6),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.08),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imagePath.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          width: size * 0.75,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap:
                                    () => _showImageDialog(context, imagePath),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(imagePath),
                                    width: size * 0.55,
                                    height: size * 0.45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _truncateFileName(imagePath.split('/').last),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: size * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
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
                        SizedBox(height: 5),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (screenWidth / 25).clamp(12, 18),
                            fontFamily: 'FranklinGothicHeavy',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (imagePath.isNotEmpty)
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: onClear,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: size * 0.1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context), // Tap anywhere to close
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(imagePath), fit: BoxFit.contain),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0x99000000),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _truncateFileName(imagePath.split('/').last),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  String _truncateFileName(String fileName) {
    if (fileName.length <= 10) return fileName; // No need to shorten
    int prefixLength = 5; // First part
    int suffixLength = 5; // Last part
    return "${fileName.substring(0, prefixLength)}...${fileName.substring(fileName.length - suffixLength)}";
  }

  //PERMISSION DENIED FUNCTION
  Future<bool> _showPermissionDeniedDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: Text("Permission Required"),
                content: Text(
                  "Please allow the app to access your camera and storage to upload a picture.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      openAppSettings();
                      Navigator.pop(context, true);
                    },
                    child: Text("Open Settings"),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Widget customContainer({
    required Widget child,
    double width = 395,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    Color color = Colors.transparent,
    double borderRadius = 5,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: child,
    );
  }

  Widget headerContainerField({
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
          fontFamily: fontFamily,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget headerTextField({
    required String text,
    Color color = Colors.black,
    double fontSize = 13,
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

  Widget buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    TextInputType keyboardType = TextInputType.name,
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    String? Function(String?)? validator,
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
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: Color(0xFF58595B),
            fontSize: 14,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
          onChanged: (value) {
            final words = value.split(' ');
            final capitalized = words
                .map(
                  (word) =>
                      word.isNotEmpty
                          ? word[0].toUpperCase() +
                              word.substring(1).toLowerCase()
                          : '',
                )
                .join(' ');

            if (capitalized != controller.text) {
              final cursorPos = controller.selection.baseOffset;
              controller.value = TextEditingValue(
                text: capitalized,
                selection: TextSelection.collapsed(offset: cursorPos),
              );
            }

            if (onChanged != null) onChanged!(capitalized);
          },
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Fill the blank field';
            }
            return null;
          },
          onTap: () {
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
          maxLines: 1,
        ),
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
          keyboardType: TextInputType.none,
        ),
      ),
    );
  }

  Widget buildStringDropdownTextField({
    required FocusNode focusNode,
    required String? value,
    required List<String> items,
    required String labelText,
    required ValueChanged<String?> onChanged,
    required VoidCallback onTapOutsideCallback,
    double width = 75,
    double height = 52,
  }) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: DropdownButtonFormField<String>(
          isDense: true,
          isExpanded: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
          value: (value == null || value.isEmpty) ? null : value,
          onChanged: onChanged,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please select $labelText';
            }
            return null;
          },
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'RobotoRegular',
                    ),
                  ),
                );
              }).toList(),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }

  Widget buildIntDropdownTextField({
    required FocusNode focusNode,
    required int? value,
    required List<int> items,
    required String labelText,
    required ValueChanged<int?> onChanged,
    String? Function(int?)? validator,
    required VoidCallback onTapOutsideCallback,
    double width = 75,
    double height = 52,
  }) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: DropdownButtonFormField<int>(
          isDense: true,
          isExpanded: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
          value: (value == null) ? null : value,
          onChanged: onChanged,
          validator: (val) {
            if (val == null) {
              return 'Please select $labelText';
            }
            return null;
          },
          items:
              items.map((int item) {
                return DropdownMenuItem<int>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 11,
                      fontFamily: 'RobotoRegular',
                    ),
                  ),
                );
              }).toList(),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }

  Widget buildPhoneTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    TextInputType keyboardType = TextInputType.phone,
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
        width: 265,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          validator: validator,
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '+63',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          onTap: () {
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          },
        ),
      ),
    );
  }

  InputDecoration customInputDecoration({
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
            color: focusNode.hasFocus ? Color(0xFFA31321) : Color(0xFF414042),
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          children: [
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'RobotoRegular',
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFF414042), width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFA31321), width: 3),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
    );
  }

  InputDecoration customReadDecoration({
    required String labelText,
    required FocusNode focusNode,
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
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
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
              boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 8)],
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

  Future<void> _fetchProfileData() async {
    final authorityVariable = Provider.of<AuthorityVariable>(
      context,
      listen: false,
    );
    final email = authorityVariable.newEmailController.text.trim();

    try {
      final query =
          await FirebaseFirestore.instance
              .collection('_authorities')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        authorityVariable.firstNameController.text = data['firstName'] ?? '';
        authorityVariable.lastNameController.text = data['lastName'] ?? '';
        authorityVariable.middleInitController.text =
            data['middleInitial'] ?? '';
        authorityVariable.monthController.text = data['birthMonth'] ?? '';
        authorityVariable.dayController.text = data['birthDay'] ?? '';
        authorityVariable.yearController.text = data['birthYear'] ?? '';
        authorityVariable.sexController.text = data['sex'] ?? '';
        authorityVariable.newEmailController.text = data['email'] ?? '';
      }
    } catch (e) {
      print('Fetch authority data error: $e');
    }
  }
}
