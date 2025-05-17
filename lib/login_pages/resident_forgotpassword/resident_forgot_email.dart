import 'package:bantay_alertdraft/login_pages/resident_forgotpassword/resident_forgot_verification_code.dart';
import 'package:bantay_alertdraft/login_pages/resident_loginpage.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ResidentForgotEmail extends StatefulWidget {
  const ResidentForgotEmail({super.key});

  @override
  _ResidentForgotEmailPage createState() => _ResidentForgotEmailPage();
}

class _ResidentForgotEmailPage extends State<ResidentForgotEmail> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  void _next() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final resVar = Provider.of<ResidentVariable>(context, listen: false);
    final email = resVar.newEmailController.text.trim();

    try {
      final query =
          await FirebaseFirestore.instance
              .collection('_residents')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email. Try again")),
        );
        setState(() => _isLoading = false);
        return;
      }
      final residentData = query.docs.first.data();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => ResidentForgotVerificationCode(
                residentData: residentData,
                email: email,
              ),
        ),
      );
    } catch (e) {
      print("Reset Password error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during password reset'),
        ),
      );
      setState(() => _isLoading = false); // Reset loading
    }
  }

  @override
  Widget build(BuildContext context) {
    final resVar = Provider.of<ResidentVariable>(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text(
                    'Forgot Password?',
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 200), () {
                        resVar.clearData();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResidentLoginPage(),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ],
          body:
              isKeyboardOpen
                  ? SingleChildScrollView(child: _buildForm(context))
                  : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = MediaQuery.of(context).size.width;
                    double horizontalPadding = screenWidth * 0.05;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Consumer<ResidentVariable>(
                        builder: (context, residentVariable, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildTextField(
                                controller: residentVariable.newEmailController,
                                focusNode: residentVariable.newEmailFocusNode,
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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          residentVariable.emailController
                                              .clear();
                                        });
                                    return "Please enter a valid email";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              buildButton("NEXT", _next),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
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
      child: OutlinedButton(
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
      ),
    );
  }
}
