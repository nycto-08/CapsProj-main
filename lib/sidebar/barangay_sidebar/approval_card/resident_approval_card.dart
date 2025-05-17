import 'dart:io';
import 'package:bantay_alertdraft/instruction_specialpop/iD_instruction/no_image_dialog.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResidentApprovalCard extends StatefulWidget {
  const ResidentApprovalCard({super.key});

  @override
  _ResidentApprovalCard createState() => _ResidentApprovalCard();
}

class _ResidentApprovalCard extends State<ResidentApprovalCard> {

  void _accept(){
    //TO-DO
  }
  
  void _reject(){
    //TO-DO
  }

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
              backgroundColor: const Color(0XFF7C0A20),
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
                  const Text(
                    "RESIDENT REQUEST",
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Consumer<ResidentVariable>(
              builder: (context, residentVariable, child){
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
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          headerContainerText(text: "RESIDENT INFORMATION"),
                          SizedBox(height: 5),
                          customContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: headerTextField(text: "Name"),
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
                                    //First Name
                                    Expanded(
                                      flex: 3,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getFirstName), 
                                        focusNode: residentVariable.firstNameFocusNode, 
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
                                        controller: TextEditingController(text: resVar.getLastName), 
                                        focusNode: residentVariable.lastNameFocusNode, 
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
                                        controller: TextEditingController(text: resVar.getMiddleInitial), 
                                        focusNode: residentVariable.middleInitialFocusNode, 
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
                                        controller: TextEditingController(text: resVar.getAge.toString()), 
                                        focusNode: residentVariable.ageFocusNode, 
                                        labelText: "Age", 
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
                                        controller: TextEditingController(text: resVar.getMonth), 
                                        focusNode: residentVariable.monthFocusNode, 
                                        labelText: "Month", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 2,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getDay.toString()), 
                                        focusNode: residentVariable.dayFocusNode, 
                                        labelText: "Day", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar  .getYear.toString()), 
                                        focusNode: residentVariable.yearFocusNode, 
                                        labelText: "Year", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getSex), 
                                        focusNode: residentVariable.sexFocusNode, 
                                        labelText: "Sex", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 5,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getCivilStatus), 
                                        focusNode: residentVariable.civilStatusFocusNode, 
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
                                        controller: TextEditingController(text: resVar.getBloodType), 
                                        focusNode: residentVariable.bloodTypeFocusNode, 
                                        labelText: "Blood Type", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: buildPhoneReadTextField(
                                        controller: TextEditingController(text: resVar.getPhoneNumber), 
                                        focusNode: residentVariable.phoneNumberFocusNode, 
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
                                  controller: TextEditingController(text: resVar.getEmail), 
                                  focusNode: residentVariable.emailFocusNode, 
                                  labelText: "Email", 
                                  onTap: () {}, 
                                  onTapOutsideCallback: () {},
                                 ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          headerContainerText(text: "Personal Address"),
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
                                        controller: TextEditingController(text: resVar.getHouseBlock), 
                                        focusNode: residentVariable.houseBlockFocusNode, 
                                        labelText: "House Block and Street", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getCityProvince), 
                                        focusNode: residentVariable.cityProvinceFocusNode, 
                                        labelText: "City/Province", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getBarangay), 
                                        focusNode: residentVariable.barangayFocusNode, 
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
                          headerContainerText(text: "Emergency  Contact Information"),
                          const SizedBox(height: 5),
                          customContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headerTextField(text: "Name"),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getNameEmergency), 
                                        focusNode: residentVariable.nameEmergencyFocusNode, 
                                        labelText: "First Name", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getLastEmergency), 
                                        focusNode: residentVariable.lastEmergencyFocusNode, 
                                        labelText: "Last Name", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getMiddleEmergency), 
                                        focusNode: residentVariable.middleEmergencyFocusNode, 
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
                                        controller: TextEditingController(text: resVar.getRelationshipEmergency), 
                                        focusNode: residentVariable.relationshipEmergencyFocusNode, 
                                        labelText: "Relationship", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: buildPhoneReadTextField(
                                        controller: TextEditingController(text: resVar.getPhoneNumberEmergency), 
                                        focusNode: residentVariable.phoneNumberEmergencyFocusNode, 
                                        labelText: "Phone Number", 
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
                                    Expanded(
                                      flex: 1,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getHouseBlockEmergency), 
                                        focusNode: residentVariable.houseBlockEmergencyFocusNode, 
                                        labelText: "House Block and Stree", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getCityProvinceEmergency), 
                                        focusNode: residentVariable.cityProvinceEmergencyFocusNode, 
                                        labelText: "City/Province", 
                                        onTap: () {}, 
                                        onTapOutsideCallback: () {}, 
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: buildReadTextField(
                                        controller: TextEditingController(text: resVar.getBarangayEmergency), 
                                        focusNode: residentVariable.barangayEmergencyFocusNode, 
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
              }),
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
                        Consumer<ResidentVariable>(
                          builder: (context, residentVariable, child) {
                            return submitImageDisplay(
                              context: context, 
                              label: "ID PICTURE\n(FRONT)", 
                              imagePath: resVar.idFrontImagePath, 
                              size: buttonSize, 
                              assetPath: "assets/frontID.png", 
                              showNoImageDialog: showNoImageDialog,
                            );
                          } 
                        ),
                        SizedBox(width: 5),
                        Consumer<ResidentVariable>(
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
    String fontFamily = 'RobotoBold',
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
