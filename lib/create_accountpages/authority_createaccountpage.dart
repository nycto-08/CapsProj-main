import 'dart:convert';
import 'package:bantay_alertdraft/create_accountpages/authority_verificationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';

class AuthorityCreateAccountPage extends StatefulWidget {
  const AuthorityCreateAccountPage({super.key});

  @override
  _AuthorityCreateAccountPage createState() => _AuthorityCreateAccountPage();
}

class _AuthorityCreateAccountPage extends State<AuthorityCreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newPasswordKey = GlobalKey<FormFieldState>();
  final confirmPasswordKey = GlobalKey<FormFieldState>();
  bool _isChecked = false;
  bool _showError = false;

  void _submit() async {
    FocusScope.of(context).unfocus();

    final authoVar = Provider.of<AuthorityVariable>(context, listen: false);
    final newPassword = authoVar.newPasswordController.text.trim();
    final confirmPassword = authoVar.confirmPassController.text.trim();

    if (_formKey.currentState!.validate()) {
      if (_isChecked) {
        final email = authoVar.newEmailController.text.trim();

        try {
          final existing =
              await FirebaseFirestore.instance
                  .collection('_authorities')
                  .where('email', isEqualTo: email)
                  .limit(1)
                  .get();

          if (existing.docs.isNotEmpty) {
            final doc = existing.docs.first;
            final authorityData = doc.data();

            if (authorityData['verified'] == false) {
              await FirebaseFirestore.instance
                  .collection('_authorities')
                  .doc(doc.id)
                  .delete();
            } else {
              //Show error and clear email and pass field
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'This email account is already registered. Try another email account.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  backgroundColor: Colors.red,
                ),
              );

              //Clear input fields
              authoVar.newEmailController.clear();
              authoVar.newPasswordController.clear();
              authoVar.confirmPassController.clear();
              if (mounted) {
                setState(() {
                  _isChecked = false;
                });
              }
              return;
            }
          }
          final hashedPassword =
              sha256.convert(utf8.encode(newPassword)).toString();

          final authorityData = {
            'firstName': authoVar.firstNameController.text.trim(),
            'lastName': authoVar.lastNameController.text.trim(),
            'middleInitial': authoVar.middleInitController.text.trim(),
            'birthMonth': authoVar.selectedMonth,
            'birthDay': authoVar.dayController.text.trim(),
            'birthYear': authoVar.yearController.text.trim(),
            'sex': authoVar.selectedSex,
            'email': email,
            'password': hashedPassword,
            'verified': false,
            'assigned': false,
            'city': 'notAssigned',
            'barangay': 'notAssigned',
            'createdAt': FieldValue.serverTimestamp(),
          };

          await FirebaseFirestore.instance
              .collection('_authorities')
              .add(authorityData);

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AuthorityVerificationPage(
                      authorityData: authorityData,
                      email: email,
                    ),
              ),
            );
          }
        } catch (e) {
          debugPrint('Error saving data: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong!')),
            );
          }
        }
      } else {
        if (mounted) setState(() => _showError = true);
      }
    } else {
      if (confirmPassword.isNotEmpty && confirmPassword != newPassword) {
        authoVar.confirmPassController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Provider.of<AuthorityVariable>(context, listen: false).clearData();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text(
                      'Create Authority Account',
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
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Provider.of<AuthorityVariable>(
                          context,
                          listen: false,
                        ).clearData();
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),
                        onPressed: () {
                          //TO - DO
                        },
                      ),
                    ],
                  ),
                ],
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Column(
                        children: [
                          Image.asset('assets/bantay_logo.png', width: 280),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "AUTHORITY",
                              style: TextStyle(
                                color: Color(0xFFA31321),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "FranklinGothicHeavy",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customContainer(
                                  context: context,
                                  child: Consumer<AuthorityVariable>(
                                    builder: (
                                      context,
                                      authorityVariable,
                                      child,
                                    ) {
                                      int daysInmonth =
                                          authorityVariable.getDaysinMonth();
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headerTextField(text: 'Name'),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: buildTextField(
                                                  controller:
                                                      authorityVariable
                                                          .firstNameController,
                                                  focusNode:
                                                      authorityVariable
                                                          .firstNameFocusNode,
                                                  labelText: 'First Name',
                                                  onTap: () {},
                                                  onTapOutsideCallback: () {},
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 3,
                                                child: buildTextField(
                                                  controller:
                                                      authorityVariable
                                                          .lastNameController,
                                                  focusNode:
                                                      authorityVariable
                                                          .lastNameFocusNode,
                                                  labelText: 'Last Name',
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
                                                          .middleInitController,
                                                  focusNode:
                                                      authorityVariable
                                                          .middleInitialFocusNode,
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
                                                  text: 'Birthdate',
                                                ),
                                              ),
                                              SizedBox(width: 225),
                                              Expanded(
                                                flex: 1,
                                                child: headerTextField(
                                                  text: 'Sex',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child:
                                                    buildStringDropdownTextField(
                                                      focusNode:
                                                          authorityVariable
                                                              .monthFocusNode,
                                                      value:
                                                          authorityVariable
                                                              .selectedMonth,
                                                      items: [
                                                        "January",
                                                        "February",
                                                        "March",
                                                        "April",
                                                        "May",
                                                        "June",
                                                        "July",
                                                        "August",
                                                        "September",
                                                        "October",
                                                        "November",
                                                        "December",
                                                      ],
                                                      labelText: "Month",
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          authorityVariable
                                                                  .selectedMonth =
                                                              newValue!;
                                                        });
                                                      },
                                                      onTapOutsideCallback:
                                                          () {},
                                                    ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: buildIntDropdownTextField(
                                                  focusNode:
                                                      authorityVariable
                                                          .dayFocusNode,
                                                  value:
                                                      authorityVariable
                                                                  .selectedDay <=
                                                              daysInmonth
                                                          ? authorityVariable
                                                              .selectedDay
                                                          : 1,
                                                  items: List.generate(
                                                    daysInmonth,
                                                    (index) => index + 1,
                                                  ),
                                                  labelText: 'Day',
                                                  onChanged: (int? newValue) {
                                                    if (newValue != null) {
                                                      authorityVariable
                                                              .selectedDay =
                                                          newValue;
                                                      authorityVariable
                                                              .dayController
                                                              .text =
                                                          newValue.toString();
                                                    }
                                                  },
                                                  onTapOutsideCallback: () {},
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 1,
                                                child: buildTextField(
                                                  controller:
                                                      authorityVariable
                                                          .yearController,
                                                  focusNode:
                                                      authorityVariable
                                                          .yearFocusNode,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatter: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                      4,
                                                    ),
                                                  ],
                                                  labelText: 'Year',
                                                  onChanged: (newValue) {
                                                    if (newValue.isNotEmpty) {
                                                      int? year = int.tryParse(
                                                        newValue,
                                                      );
                                                      if (year != null) {
                                                        if (year < 0000) {
                                                          authorityVariable
                                                              .yearController
                                                              .text = '1900';
                                                        } else if (year >=
                                                            2031) {
                                                          authorityVariable
                                                              .yearController
                                                              .text = '2030';
                                                        }
                                                        authorityVariable
                                                                .yearController
                                                                .selection =
                                                            TextSelection.fromPosition(
                                                              TextPosition(
                                                                offset:
                                                                    authorityVariable
                                                                        .yearController
                                                                        .text
                                                                        .length,
                                                              ),
                                                            );
                                                      }
                                                    }
                                                  },
                                                  onTap: () {},
                                                  onTapOutsideCallback: () {},
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 1,
                                                child:
                                                    buildStringDropdownTextField(
                                                      focusNode:
                                                          authorityVariable
                                                              .sexFocusNode,
                                                      value:
                                                          authorityVariable
                                                                  .selectedSex
                                                                  .isEmpty
                                                              ? null
                                                              : authorityVariable
                                                                  .selectedSex,
                                                      items: ["M", "F"],
                                                      labelText: 'Sex',
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          authorityVariable
                                                                  .selectedSex =
                                                              newValue!;
                                                        });
                                                      },
                                                      onTapOutsideCallback:
                                                          () {},
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                customContainer(
                                  context: context,
                                  child: Consumer<AuthorityVariable>(
                                    builder: (
                                      context,
                                      authorityVariable,
                                      child,
                                    ) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headerTextField(
                                            text: 'Email Address',
                                          ),
                                          const SizedBox(height: 5),
                                          buildEmailTextField(
                                            width: 395,
                                            controller:
                                                authorityVariable
                                                    .newEmailController,
                                            focusNode:
                                                authorityVariable
                                                    .newEmailFocusNode,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            labelText: "New Email Address",
                                            onTap: () {},
                                            onTapOutsideCallback: () {},
                                            validator: (value) {
                                              RegExp emailRegex = RegExp(
                                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                              );
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  !emailRegex.hasMatch(value)) {
                                                return "Please enter a valid email";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          headerTextField(text: 'Password'),
                                          const SizedBox(height: 5),
                                          buildPasswordField(
                                            controller:
                                                authorityVariable
                                                    .newPasswordController,
                                            focusNode:
                                                authorityVariable
                                                    .newPasswordFocusNode,
                                            labelText: 'New Password',
                                            fieldKey: newPasswordKey,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Password cannot be empty.";
                                              }
                                              if (value.length < 6) {
                                                return "Password must be at least 6 characters long.";
                                              }
                                              if (!RegExp(
                                                r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$',
                                              ).hasMatch(value)) {
                                                return "Password must contain both letters and numbers.";
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                // Rebuild widget when password is typed to update confirm password field
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          headerTextField(
                                            text: "Confirm Password",
                                          ),
                                          const SizedBox(height: 5),
                                          buildPasswordField(
                                            controller:
                                                authorityVariable
                                                    .confirmPassController,
                                            focusNode:
                                                authorityVariable
                                                    .confirmPasswordFocusNode,
                                            labelText: 'Confirm New Password',
                                            fieldKey: confirmPasswordKey,
                                            enabled:
                                                authorityVariable
                                                    .newPasswordController
                                                    .text
                                                    .isNotEmpty,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please confirm your password";
                                              }
                                              if (value !=
                                                  authorityVariable
                                                      .newPasswordController
                                                      .text) {
                                                return "Passwords do not match.";
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {},
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: .8,
                                          child: Checkbox(
                                            value: _isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                _isChecked = value!;
                                                if (_isChecked) {
                                                  _showError = false;
                                                }
                                              });
                                            },
                                            activeColor: Color(0xFFA31321),
                                          ),
                                        ),
                                        SizedBox(width: .5),
                                        const Text(
                                          "I have read the ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Montserrat",
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //TO-DO
                                          },
                                          child: Text(
                                            "terms & agreement",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              color: Color(0xFFA31321),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_showError && !_isChecked)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "You must accept the Terms & Agreement.",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFA31321),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 36,
                                          vertical: 16,
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Montserrat-ExtraBold",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customContainer({
    required BuildContext context,
    required Widget child,
    double widthFactor = 0.95, // fraction of screen width
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    Color color = Colors.transparent,
    double borderRadius = 5,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * widthFactor,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [BoxShadow(color: Color(0xFFE59CA7), offset: Offset(2, 2))],
      ),
      child: child,
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
    TextCapitalization textCapitalization = TextCapitalization.words,
    List<TextInputFormatter>? inputFormatter,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatter,
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

  Widget buildEmailTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required VoidCallback onTap,
    required VoidCallback onTapOutsideCallback,
    TextInputType keyboardType = TextInputType.name,
    TextInputAction textInputAction = TextInputAction.next,
    TextCapitalization textCapitalization = TextCapitalization.words,
    List<TextInputFormatter>? inputFormatter,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatter,
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
          onChanged: onChanged,
          validator: validator,
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

  Widget buildStringDropdownTextField({
    required FocusNode focusNode,
    required String? value,
    required List<String> items,
    required String labelText,
    required ValueChanged<String?> onChanged,
    required VoidCallback onTapOutsideCallback,
    GlobalKey<FormFieldState>? fieldKey,
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
          key: fieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isDense: true,
          isExpanded: true,
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
          focusNode: focusNode,
          value: value,
          onChanged: onChanged,
          items:
              items.map((int item) {
                return DropdownMenuItem<int>(
                  value: item,
                  child: Text(
                    item.toString(),
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

  Widget buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    GlobalKey<FormFieldState>? fieldKey,
    bool enabled = true,
  }) {
    bool isPasswordVisible = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          key: fieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          focusNode: focusNode,
          obscureText: !isPasswordVisible,

          enabled: enabled,
          style: const TextStyle(
            color: Color(0xFF58595B),
            fontSize: 14,
            fontFamily: 'RobotoRegular',
          ),
          decoration: customInputDecoration(
            labelText: labelText,
            focusNode: focusNode,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color:
                    isPasswordVisible ? Color(0xFFA31321) : Color(0xFF414042),
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
          onChanged: (value) {
            if (onChanged != null) onChanged(value);
          },
          validator: validator,
        );
      },
    );
  }

  InputDecoration customInputDecoration({
    required String labelText,
    required FocusNode focusNode,
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
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
    );
  }
}
