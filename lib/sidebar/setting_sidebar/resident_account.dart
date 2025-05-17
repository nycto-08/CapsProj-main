import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:bantay_alertdraft/instruction_specialpop/iD_instruction/no_image_dialog.dart';

class ResidentAccount extends StatefulWidget {
  const ResidentAccount({super.key});

  @override
  _ResidentAccount createState() => _ResidentAccount();
}

class _ResidentAccount extends State<ResidentAccount> {
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    final resVar = Provider.of<ResidentVariable>(context);
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
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Account",
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
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isEditing ? Icons.save : Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                          if (!isEditing) {
                            //TO-DO
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Consumer<ResidentVariable>(
                  builder: (context, residentVariable, child) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              resVar.getProfileImage != null
                                  ? FileImage(resVar.getProfileImage!)
                                  : null,
                          child:
                              resVar.profileImage == null
                                  ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'RESIDENT',
                          style: TextStyle(
                            color: Color(0xFF414042),
                            fontFamily: 'RobotoBold',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          resVar.getCityProvince.isEmpty
                              ? "No City Selected"
                              : resVar.getCityProvince,
                          style: TextStyle(
                            color: Color(0xFF7C0A20),
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              headerContainerText(text: "My Personal Information"),
                              SizedBox(height: 5),
                              customContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        headerTextField(text: " Name"),
                                        const SizedBox(width: 278),
                                        headerTextField(text: "Age"),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        //First Name
                                        buildNameTextField(
                                          controller: TextEditingController(
                                            text: resVar.getFirstName,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .firstNameFocusNode,
                                          labelText: "First Name",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        //Last Name
                                        buildNameTextField(
                                          controller: TextEditingController(
                                            text: resVar.getLastName,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .lastNameFocusNode,
                                          labelText: "Last Name",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        //Middle Name
                                        buildMiddleNameTextField(
                                          controller: TextEditingController(
                                            text: resVar.getMiddleInitial,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .middleInitialFocusNode,
                                          labelText: "M.I.",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        //Age
                                        buildAgeTextField(
                                          controller: TextEditingController(
                                            text: resVar.getAge.toString(),
                                          ),
                                          focusNode:
                                              residentVariable.ageFocusNode,
                                          labelText: "Age",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        headerTextField(text: " Birthdate"),
                                        const SizedBox(width: 155),
                                        headerTextField(text: "Sex"),
                                        const SizedBox(width: 45),
                                        headerTextField(text: "CivilStatus"),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        buildMonthTextField(
                                          controller: TextEditingController(
                                            text: resVar.getMonth,
                                          ),
                                          focusNode:
                                              residentVariable.monthFocusNode,
                                          labelText: "Month",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 5),
                                        buildDayTextField(
                                          controller: TextEditingController(
                                            text: resVar.getDay.toString(),
                                          ),
                                          focusNode:
                                              residentVariable.dayFocusNode,
                                          labelText: "Day",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 5),
                                        buildYearTextField(
                                          controller: TextEditingController(
                                            text: resVar.getYear.toString(),
                                          ),
                                          focusNode:
                                              residentVariable.yearFocusNode,
                                          labelText: "Year",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 20),
                                        buildSexTextField(
                                          controller: TextEditingController(
                                            text: resVar.getSex,
                                          ),
                                          focusNode:
                                              residentVariable.sexFocusNode,
                                          labelText: "Sex",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildCivilStatusTextField(
                                          controller: TextEditingController(
                                            text: resVar.getCivilStatus,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .civilStatusFocusNode,
                                          labelText: "Civil Status",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        headerTextField(text: " Blood Type"),
                                        const SizedBox(width: 30),
                                        headerTextField(text: "Phone Number"),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        buildBloodTypeTextField(
                                          controller: TextEditingController(
                                            text: resVar.getBloodType,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .bloodTypeFocusNode,
                                          labelText: "Blood Type",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                          isEditing: isEditing,
                                        ),
                                        const SizedBox(width: 5),
                                        buildPhoneTextField(
                                          controller: TextEditingController(
                                            text: resVar.getPhoneNumber,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .phoneNumberFocusNode,
                                          labelText: "Phone Number",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                          isEditing: isEditing,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    headerTextField(text: "Email"),
                                    const SizedBox(height: 5),
                                    buildEmailTextField(
                                      controller: TextEditingController(
                                        text: resVar.getEmail,
                                      ),
                                      focusNode:
                                          residentVariable.emailFocusNode,
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
                                        buildhouseBlockTextField(
                                          controller: TextEditingController(
                                            text: resVar.getHouseBlock,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .houseBlockFocusNode,
                                          labelText: "House Block and Street",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildCityProvinceTextField(
                                          controller: TextEditingController(
                                            text: resVar.getCityProvince,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .cityProvinceFocusNode,
                                          labelText: "City/Province",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildBarangayTextField(
                                          controller: TextEditingController(
                                            text: resVar.getBarangay,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .barangayFocusNode,
                                          labelText: "Barangay",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              headerContainerText(
                                text: "Emergency Contact Information",
                              ),
                              const SizedBox(height: 5),
                              customContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    headerTextField(text: "Name"),
                                    Row(
                                      children: [
                                        buildNameTextField(
                                          controller: TextEditingController(
                                            text: resVar.getNameEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .nameEmergencyFocusNode,
                                          labelText: "First Name",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildNameTextField(
                                          controller: TextEditingController(
                                            text: resVar.getLastEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .lastEmergencyFocusNode,
                                          labelText: "Last Name",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildMiddleNameTextField(
                                          controller: TextEditingController(
                                            text: resVar.getMiddleEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .middleEmergencyFocusNode,
                                          labelText: "M.I.",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        headerTextField(text: "Relationship"),
                                        const SizedBox(width: 20),
                                        headerTextField(text: "Phone Number"),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        buildRelationshipTextField(
                                          controller: TextEditingController(
                                            text:
                                                resVar.getRelationshipEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .relationshipEmergencyFocusNode,
                                          labelText: "Relationship",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                          isEditing: isEditing,
                                        ),
                                        const SizedBox(width: 5),
                                        buildPhoneTextField(
                                          controller: TextEditingController(
                                            text:
                                                resVar.getPhoneNumberEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .phoneNumberEmergencyFocusNode,
                                          labelText: "Phone Number",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                          isEditing: isEditing,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              headerContainerText(
                                text: "Emergency Contact Address",
                              ),
                              const SizedBox(height: 5),
                              customContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        buildhouseBlockTextField(
                                          controller: TextEditingController(
                                            text: resVar.getHouseBlockEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .houseBlockEmergencyFocusNode,
                                          labelText: "House Block and Street",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildCityProvinceTextField(
                                          controller: TextEditingController(
                                            text:
                                                resVar.getCityProvinceEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .cityProvinceEmergencyFocusNode,
                                          labelText: "City/Province",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
                                        ),
                                        const SizedBox(width: 10),
                                        buildBarangayTextField(
                                          controller: TextEditingController(
                                            text: resVar.getBarangayEmergency,
                                          ),
                                          focusNode:
                                              residentVariable
                                                  .barangayEmergencyFocusNode,
                                          labelText: "Barangay",
                                          onTap: () {},
                                          onTapOutsideCallback: () {},
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
                if (!isEditing)
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
                          Consumer<ResidentVariable>(
                            builder: (context, residentVariable, child){
                              return submitImageDisplay(
                                context: context,
                                label: "ID PICTURE\n(FRONT)",
                                imagePath: resVar.idFrontImagePath,
                                size: buttonSize,
                                assetPath: "assets/frontID.png",
                                showNoImageDialog: showNoImageDialog,
                              );
                            },
                          ),
                          SizedBox(width: 5),
                          Consumer <ResidentVariable>(
                            builder: (context, residentVariable, child) {
                              return submitImageDisplay(
                                context: context,
                                label: "ID PICTURE\n(BACK)",
                                imagePath: resVar.idBackImagePath,
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

  Widget buildNameTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 120,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildMiddleNameTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 45,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildAgeTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 50,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildMonthTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 75,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildDayTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 60,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildYearTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 50,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildSexTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 60,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildCivilStatusTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 80,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildBloodTypeTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    required bool isEditing,
  }) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.selection = const TextSelection.collapsed(offset: 0);
      }
    });
    final List<String> bloodtypeitems = [
      "A+",
      "A-",
      "B+",
      "B-",
      "O+",
      "O-",
      "AB+",
      "AB-",
      "Unknown",
    ];
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: 95,
        height: 52,
        child:
            isEditing
                ? DropdownButtonFormField<String>(
                  value:
                      bloodtypeitems.contains(controller.text)
                          ? controller.text
                          : null,
                  items:
                      bloodtypeitems.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'RobotoRegular',
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (newValueBloodType) {
                    if (newValueBloodType != null) {
                      controller.text = newValueBloodType;
                      //DATABASE FUNCTION
                    }
                  },
                  iconSize: 14,
                  icon: const Padding(
                    padding: EdgeInsets.only(
                      right: .85,
                    ), // Adjust spacing between text and arrow
                    child: Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                  isDense: true,
                  isExpanded: true,
                  decoration: customRequiredInputDecoration(
                    labelText: labelText,
                    focusNode: focusNode,
                  ),
                )
                : TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: true,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color(0xFF58595B),
                    fontSize: 12,
                    fontFamily: 'RobotoRegular',
                  ),
                  decoration: customInputDecoration(
                    labelText: labelText,
                    focusNode: focusNode,
                  ),
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

  Widget buildPhoneTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    required bool isEditing,
  }) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.selection = const TextSelection.collapsed(offset: 0);
      }
    });

    // Default values
    String phoneNumberText = controller.text;
    String countryCode = "PH"; // Set to "PH" explicitly
    String localNumber = phoneNumberText;

    if (phoneNumberText.startsWith("+")) {
      final match = RegExp(r"(\+\d{1,4})(\d+)").firstMatch(phoneNumberText);
      if (match != null) {
        String extractedCode = match.group(1) ?? "+63";
        localNumber = match.group(2) ?? "";

        // Ensure correct mapping of country code
        if (extractedCode == "+63") countryCode = "PH";
      }
    }

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: 265,
        height: 52,
        child: IntlPhoneField(
          controller: controller, // Keep full number in controller
          focusNode: focusNode,
          initialCountryCode: countryCode, // Use "PH" directly
          initialValue: phoneNumberText, // Set full number for proper parsing
          keyboardType: TextInputType.phone,
          readOnly: !isEditing,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration:
              isEditing
                  ? customRequiredInputDecoration(
                    labelText: labelText,
                    focusNode: focusNode,
                  )
                  : customInputDecoration(
                    labelText: labelText,
                    focusNode: focusNode,
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

  Widget buildEmailTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 365,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  //Personal Address FUNCTION

  Widget buildhouseBlockTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 130,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildCityProvinceTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 130,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildBarangayTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
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
        width: 85,
        height: 52,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xFF58595B),
            fontSize: 12,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
          ),
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

  Widget buildRelationshipTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    required bool isEditing,
  }) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.selection = const TextSelection.collapsed(offset: 0);
      }
    });
    final List<String> relationshipitems = [
      "Single",
      "Guardian",
      "Sibling",
      "Child",
      "Spouse",
      "Friend/Acquaintance",
    ];
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        onTapOutsideCallback();
      },
      child: SizedBox(
        width: 95,
        height: 52,
        child:
            isEditing
                ? DropdownButtonFormField<String>(
                  value:
                      relationshipitems.contains(controller.text)
                          ? controller.text
                          : null,
                  items:
                      relationshipitems.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'RobotoRegular',
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (newValueBloodType) {
                    if (newValueBloodType != null) {
                      controller.text = newValueBloodType;
                      //DATABASE FUNCTION
                    }
                  },
                  iconSize: 14,
                  icon: const Padding(
                    padding: EdgeInsets.only(
                      right: .5,
                    ), // Adjust spacing between text and arrow
                    child: Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                  isDense: true,
                  isExpanded: true,
                  decoration: customRequiredInputDecoration(
                    labelText: labelText,
                    focusNode: focusNode,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'RobotoRegular',
                  ),
                )
                : TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: true,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color(0xFF58595B),
                    fontSize: 12,
                    fontFamily: 'RobotoRegular',
                  ),
                  decoration: customInputDecoration(
                    labelText: labelText,
                    focusNode: focusNode,
                  ),
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

  InputDecoration customInputDecoration({
    required String labelText,
    required FocusNode focusNode,
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
      filled: true,
      fillColor: Colors.white,
    );
  }

  InputDecoration customRequiredInputDecoration({
    required String labelText,
    required FocusNode focusNode,
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
