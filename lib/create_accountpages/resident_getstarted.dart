import 'dart:io';
import 'dart:math' as math;
import 'package:bantay_alertdraft/instruction_specialpop/logout_confirmation/logoutdialogbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:bantay_alertdraft/instruction_specialpop/iD_instruction/front_back_id.dart';
import 'package:bantay_alertdraft/instruction_specialpop/resident_submit/resident_success_submit.dart';

class ResidentGetStartedPage extends StatefulWidget {
  const ResidentGetStartedPage({super.key});

  @override
  State<ResidentGetStartedPage> createState() => _ResidentGetStartedPage();
}

class _ResidentGetStartedPage extends State<ResidentGetStartedPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfileData();
      Provider.of<ResidentVariable>(
        context,
        listen: false,
      ).initializeCityBarangay();
    });
  }

  void _done() async {
    FocusScope.of(context).unfocus();

    final resVar = Provider.of<ResidentVariable>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      try {
        String cityName = resVar.selectedCityProvince;
        String barangayName = resVar.selectedBarangay;
        final email = resVar.newEmailController.text.trim();

        final residentQuery =
            await FirebaseFirestore.instance
                .collection('_residents')
                .where('email', isEqualTo: email)
                .limit(1)
                .get();

        if (residentQuery.docs.isEmpty) {
          throw Exception("No matching account found in residents.");
        }

        final residentDocId = residentQuery.docs.first.id;

        final residentData = {
          //Personal Info
          'firstName': resVar.firstNameController.text.trim(),
          'lastName': resVar.lastNameController.text.trim(),
          'middleInitial': resVar.middleInitController.text.trim(),
          'age': resVar.selectedAge,
          'birthMonth': resVar.monthController.text.trim(),
          'birthDay': resVar.dayController.text.trim(),
          'birthYear': resVar.yearController.text.trim(),
          'sex': resVar.sexController.text.trim(),
          'civilStatus': resVar.selectedCivilStatus,
          'bloodType': resVar.selectedBloodType,
          'contactNumber': resVar.phoneNumberController.text.trim(),
          'email': email,
          //Personal Address
          'houseBlock': resVar.houseBlockController.text.trim(),
          'city': cityName,
          'barangay': barangayName,
          //Emergency Contact
          'emergencyFirstName': resVar.nameEmergencyController.text.trim(),
          'emergencyLastName': resVar.lastEmergencyController.text.trim(),
          'emergencyMiddleInitial': resVar.middleInitController.text.trim(),
          'emergencyRelationship': resVar.selectedRelationship,
          'emergencyPhoneNumber':
              resVar.phoneNumberEmergencyController.text.trim(),
          //Emergency Contact Address
          'emergencyHouseBlock':
              resVar.houseBlockEmergencyController.text.trim(),
          'emergencyCity': resVar.cityProvinceEmergencyController.text.trim(),
          'emergencyBarangay': resVar.barangayEmergencyController.text.trim(),
          'approved': false,
        };

        await FirebaseFirestore.instance
            .collection("city")
            .doc(cityName)
            .collection("barangay")
            .doc(barangayName)
            .collection("residents")
            .add(residentData);

        await FirebaseFirestore.instance
            .collection('_residents')
            .doc(residentDocId)
            .update({
              'city': cityName,
              'barangay': barangayName,
              'assigned': true,
            });

        if (mounted) {
          showResidentSuccessDialog(context);
        }
      } catch (e) {
        debugPrint("Error saving data: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong!')),
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
                        showGetStartedLogoutDialog(context);
                      },
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ),
                    title: Text(
                      'Get Started (Resident Account)',
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
                        Consumer<ResidentVariable>(
                          builder: (context, residentVariable, child) {
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
                                      residentVariable.profileImage != null
                                          ? FileImage(
                                            residentVariable.profileImage!,
                                          )
                                          : null,
                                  child:
                                      residentVariable.profileImage == null
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
                                    _showImagePicker(context, residentVariable);
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: headerContainerField(
                                                text: "My Personal Information",
                                              ),
                                            ),
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
                                                        residentVariable
                                                            .firstNameController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .lastNameController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .middleInitController,
                                                    focusNode:
                                                        residentVariable
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
                                                            residentVariable
                                                                .ageFocusNode,
                                                        value:
                                                            residentVariable
                                                                .selectedAge,
                                                        items: ageList,
                                                        labelText: "Age",
                                                        onChanged: (
                                                          int? ageValue,
                                                        ) {
                                                          residentVariable
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
                                                        residentVariable
                                                            .monthController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .dayController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .yearController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .sexController,
                                                    focusNode:
                                                        residentVariable
                                                            .sexFocusNode,
                                                    labelText: "Sex",
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //CIVIL STATUS
                                                Expanded(
                                                  flex: 4,
                                                  child: buildStringDropdownTextField(
                                                    focusNode:
                                                        residentVariable
                                                            .civilStatusFocusNode,
                                                    value:
                                                        residentVariable
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
                                                        residentVariable
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
                                                        residentVariable
                                                            .bloodTypeFocusNode,
                                                    value:
                                                        residentVariable
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
                                                        residentVariable
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
                                                        residentVariable
                                                            .phoneNumberController,
                                                    focusNode:
                                                        residentVariable
                                                            .phoneNumberFocusNode,
                                                    labelText: 'Phone Number',
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                        10,
                                                      ),
                                                    ],
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
                                              text: 'Email Address',
                                            ),
                                            const SizedBox(height: 5),
                                            //EMAIL
                                            buildReadTextField(
                                              width: 375,
                                              controller:
                                                  residentVariable
                                                      .newEmailController,
                                              focusNode:
                                                  residentVariable
                                                      .emailFocusNode,
                                              labelText: 'Email Address',
                                              onTap: () {},
                                              onTapOutsideCallback: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
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
                                                        residentVariable
                                                            .houseBlockController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .cityProvinceFocusNode,
                                                    value:
                                                        residentVariable
                                                            .selectedCityProvince,
                                                    items:
                                                        residentVariable
                                                            .cityToBarangayMap
                                                            .keys
                                                            .toList(),
                                                    labelText: 'City/Province',
                                                    onChanged: (
                                                      String? newCityProvince,
                                                    ) {
                                                      if (newCityProvince !=
                                                          null) {
                                                        residentVariable
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
                                                        residentVariable
                                                            .barangayFocusNode,
                                                    value:
                                                        residentVariable
                                                            .selectedBarangay,
                                                    items:
                                                        residentVariable
                                                            .availableBarangays,
                                                    labelText: 'Barangay',
                                                    onChanged: (
                                                      String? newBarangay,
                                                    ) {
                                                      if (newBarangay != null) {
                                                        residentVariable
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
                                      const SizedBox(height: 5),
                                      customContainer(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: headerContainerField(
                                                text:
                                                    'Emergency Contact Information',
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            headerTextField(text: 'Name'),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                //EMERGENCY NAME
                                                Expanded(
                                                  flex: 2,
                                                  child: buildTextField(
                                                    controller:
                                                        residentVariable
                                                            .nameEmergencyController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .lastEmergencyController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .middleEmergencyController,
                                                    focusNode:
                                                        residentVariable
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
                                                        residentVariable
                                                            .relationshipEmergencyFocusNode,
                                                    value:
                                                        residentVariable
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
                                                        residentVariable
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
                                                        residentVariable
                                                            .phoneNumberEmergencyController,
                                                    focusNode:
                                                        residentVariable
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
                                      const SizedBox(height: 5),
                                      customContainer(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: headerContainerField(
                                                text:
                                                    "Emergency Contact Address",
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
                                                        residentVariable
                                                            .houseBlockEmergencyController,
                                                    focusNode:
                                                        residentVariable
                                                            .houseBlockEmergencyFocusNode,
                                                    labelText:
                                                        'House Block and Street',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //CITY/PROVINCE
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        residentVariable
                                                            .cityProvinceEmergencyController,
                                                    focusNode:
                                                        residentVariable
                                                            .cityProvinceEmergencyFocusNode,
                                                    labelText: 'City/Province',
                                                    onTap: () {},
                                                    onTapOutsideCallback: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                //BARANGAY
                                                Expanded(
                                                  flex: 1,
                                                  child: buildTextField(
                                                    controller:
                                                        residentVariable
                                                            .barangayEmergencyController,
                                                    focusNode:
                                                        residentVariable
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
                          width: 375,
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
                                  Consumer<ResidentVariable>(
                                    builder: (
                                      context,
                                      residentVariable,
                                      child,
                                    ) {
                                      return Expanded(
                                        flex: 1,
                                        child: _iDUploadButton(
                                          context,
                                          residentVariable.idFrontImagePath,
                                          "ID PICTURE\n(FRONT)",
                                          'assets/frontID.png',
                                          buttonSize,
                                          screenWidth,
                                          () => _showFrontIDPicker(
                                            context,
                                            residentVariable,
                                          ),
                                          () => residentVariable
                                              .setidFrontImagePath(null),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Consumer<ResidentVariable>(
                                      builder: (
                                        context,
                                        residentVariable,
                                        child,
                                      ) {
                                        return _iDUploadButton(
                                          context,
                                          residentVariable.idBackImagePath,
                                          "ID PICTURE\n(BACK)",
                                          'assets/backID.png',
                                          buttonSize,
                                          screenWidth,
                                          () => _showBackIDPicker(
                                            context,
                                            residentVariable,
                                          ),
                                          () => residentVariable
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
    ResidentVariable residentVariable,
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
        return _showImagePicker(context, residentVariable);
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
                            residentVariable.setProfileImage(image);
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
                            residentVariable.setProfileImage(image);
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
    ResidentVariable residentVariable,
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
        return _showFrontIDPicker(context, residentVariable);
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
                            residentVariable.setidFrontImagePath(image);
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
                            residentVariable.setidFrontImagePath(image);
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
    ResidentVariable residentVariable,
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
        return _showBackIDPicker(context, residentVariable);
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
                            residentVariable.setidBackImagePath(image);
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
                            residentVariable.setidBackImagePath(image);
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
                    color: Colors.black.withOpacity(
                      0.6,
                    ), // Semi-transparent background
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
          validator: validator,
          style: const TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
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
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
    );
  }

  //READ FROM DATABASE
  Future<void> _fetchProfileData() async {
    final residentVariable = Provider.of<ResidentVariable>(
      context,
      listen: false,
    );
    final email = residentVariable.newEmailController.text.trim();

    try {
      final query =
          await FirebaseFirestore.instance
              .collection('_residents')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();

        residentVariable.firstNameController.text = data['firstName'] ?? '';
        residentVariable.lastNameController.text = data['lastName'] ?? '';
        residentVariable.middleInitController.text =
            data['middleInitial'] ?? '';
        residentVariable.monthController.text = data['birthMonth'] ?? '';
        residentVariable.dayController.text = data['birthDay'] ?? '';
        residentVariable.yearController.text = data['birthYear'] ?? '';
        residentVariable.sexController.text = data['sex'] ?? '';
        residentVariable.newEmailController.text = data['email'] ?? '';
      }
    } catch (e) {
      print("Fetch resident error: $e");
    }
  }
}
