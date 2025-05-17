import 'dart:convert';

import 'package:bantay_alertdraft/create_accountpages/resident_getstarted.dart';
import 'package:bantay_alertdraft/create_accountpages/resident_verificationpage.dart';
import 'package:bantay_alertdraft/instruction_specialpop/resident_submit/resident_wait_accepted_page.dart';
import 'package:bantay_alertdraft/login_pages/resident_forgotpassword/resident_forgot_email.dart';
import 'package:bantay_alertdraft/main_page/resident_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/create_accountpages/resident_createaccountpage.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentLoginPage extends StatefulWidget {
  const ResidentLoginPage({super.key});

  @override
  _ResidentLoginPageState createState() => _ResidentLoginPageState();
}

class _ResidentLoginPageState extends State<ResidentLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final resVar = Provider.of<ResidentVariable>(context, listen: false);
    final email = resVar.emailController.text.trim();
    final password = resVar.passwordController.text.trim();

    try {
      final query =
          await FirebaseFirestore.instance
              .collection('_residents')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        resVar.passwordController.clear();
        return;
      }

      final resident = query.docs.first;
      final residentData = resident.data();

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      if (residentData['password'] != hashedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
        setState(() => _isLoading = false);
        resVar.passwordController.clear();
        return;
      }

      if (residentData['verified'] == true) {
        // Get city and barangay from resident data
        final cityName = residentData['city'];
        final barangayName = residentData['barangay'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('_residents_email', residentData['email'] ?? '');
        await prefs.setString(
          '_residents_firstName',
          residentData['firstName'] ?? '',
        );
        await prefs.setString(
          '_residents_lastName',
          residentData['lastName'] ?? '',
        );
        await prefs.setString(
          '_residents_middleInitial',
          residentData['middleInitial'] ?? '',
        );

        resVar.newEmailController.text = residentData['email'] ?? '';
        resVar.emailController.text = residentData['email'] ?? '';
        resVar.firstNameController.text = residentData['firstName'] ?? '';
        resVar.middleInitController.text = residentData['middleInitial'] ?? '';
        resVar.lastNameController.text = residentData['lastName'] ?? '';

        resVar.setEmail(residentData['email'] ?? '');

        if (residentData['assigned'] == true) {
          final assignedDocRef = FirebaseFirestore.instance
              .collection("city")
              .doc(cityName)
              .collection("barangay")
              .doc(barangayName)
              .collection("residents")
              .where("email", isEqualTo: email)
              .limit(1);

          assignedDocRef.snapshots().listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              final data = snapshot.docs.first.data();
              final isApproved = data['approved'] == true;

              if (isApproved) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ResidentMainPage()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ResidentWaitAcceptedPage()),
                );
              }
            }
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ResidentGetStartedPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email first.'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => ResidentVerificationPage(
                  residentData: residentData,
                  email: email,
                ),
          ),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during login.')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resVar = Provider.of<ResidentVariable>(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFA31321),
                    Color(0xFFD88990),
                    Color(0xFFEFEDED),
                    Color(0xFFF0F0F0),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0, 0.1, 0.2, 0.7, 1.0],
                ),
              ),
            ),

            // Content with Scroll
            LayoutBuilder(
              builder: (context, constraints) {
                final content = buildLoginForm(resVar, height, width);

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  physics: const ClampingScrollPhysics(),
                  child: SafeArea(child: content),
                );
              },
            ),

            // Back Button
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFA31321),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 200), () {
                      resVar.clearData();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginForm(
    ResidentVariable residentVariable,
    double height,
    double width,
  ) {
    return Column(
      children: [
        const SizedBox(height: 85),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/bantay_logo.png', width: width * 0.65),
              const SizedBox(height: 15),
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
                  "RESIDENT",
                  style: TextStyle(
                    color: Color(0xFF414042),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "FranklinGothicHeavy",
                  ),
                ),
              ),
              const SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        controller: residentVariable.emailController,
                        focusNode: residentVariable.emailFocusNode,
                        labelText: "Email Address",
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          RegExp emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (value == null ||
                              value.isEmpty ||
                              !emailRegex.hasMatch(value)) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              residentVariable.emailController.clear();
                            });
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      buildTextField(
                        controller: residentVariable.passwordController,
                        focusNode: residentVariable.passwordFocusNode,
                        labelText: "Password",
                        prefixIcon: Icons.lock,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:
                                _isPasswordVisible
                                    ? Color(0xFFA31321)
                                    : Color(0xFF414042),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              residentVariable.passwordController.clear();
                            });
                            return "Wrong Password. Try Again.";
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResidentForgotEmail(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFFA31321),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      //Login
                      buildButton("LOGIN", _login),
                      const SizedBox(height: 35),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ResidentCreateAccountPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA31321),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: focusNode.hasFocus ? Color(0xFFA31321) : Color(0xFF414042),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: focusNode.hasFocus ? Color(0xFFA31321) : Color(0xFF414042),
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF414042), width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFA31321), width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 3),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget buildButton(
    String text,
    VoidCallback onPressed, {
    Color backgroundColor = const Color(0xFFA31321),
    Color textColor = Colors.white,
    Widget? icon,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Color(0xFFA31321), width: 3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) icon,
                    if (icon != null) const SizedBox(width: 10),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              )
              : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
    );
  }
}
