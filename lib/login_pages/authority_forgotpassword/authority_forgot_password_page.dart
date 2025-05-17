import 'dart:convert';
import 'package:bantay_alertdraft/login_pages/authority_forgotpassword/authority_forgot_email.dart';
import 'package:bantay_alertdraft/login_pages/authority_loginpage.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AuthorityForgotPasswordPage extends StatefulWidget {
  final String email;
  AuthorityForgotPasswordPage({required this.email});

  @override
  _AuthorityForgotPasswordPage createState() => _AuthorityForgotPasswordPage();
}

class _AuthorityForgotPasswordPage extends State<AuthorityForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordKey = GlobalKey<FormFieldState>();
  final confirmPasswordKey = GlobalKey<FormFieldState>();
  bool _isLoading = true;

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authoVar = Provider.of<AuthorityVariable>(context, listen: false);
    final newPassword = authoVar.newPasswordController.text.trim();
    final confirmPassword = authoVar.confirmPassController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Find the resident by email
      final residentQuery =
          await FirebaseFirestore.instance
              .collection('_authorities')
              .where('email', isEqualTo: widget.email)
              .limit(1)
              .get();

      if (residentQuery.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not found')));
        setState(() => _isLoading = false);
        return;
      }

      final residentDocId = residentQuery.docs.first.id;
      final hashedPassword =
          sha256.convert(utf8.encode(newPassword)).toString();

      await FirebaseFirestore.instance
          .collection('_authorities')
          .doc(residentDocId)
          .update({'password': hashedPassword});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear fields
      authoVar.newPasswordController.clear();
      authoVar.confirmPassController.clear();

      // Navigate to login or success screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AuthorityLoginPage()),
        );
      }
    } catch (e) {
      debugPrint("Error updating password: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong!')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authoVar = Provider.of<AuthorityVariable>(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text(
                    'Reset your Password',
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
                        authoVar.clearData();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AuthorityForgotEmail(),
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
                      child: Consumer<AuthorityVariable>(
                        builder: (context, authorityVariable, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildPasswordField(
                                controller:
                                    authorityVariable.newPasswordController,
                                focusNode:
                                    authorityVariable.newPasswordFocusNode,
                                labelText: "New Password",
                                fieldKey: newPasswordKey,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
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
                              buildPasswordField(
                                controller:
                                    authorityVariable.confirmPassController,
                                focusNode:
                                    authorityVariable.confirmPasswordFocusNode,
                                labelText: "Confirm New Password",
                                fieldKey: confirmPasswordKey,
                                enabled:
                                    authorityVariable
                                        .newPasswordController
                                        .text
                                        .isNotEmpty,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
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
                              const SizedBox(height: 30),
                              buildButton("SUBMIT", _submit),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red, width: 2),
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
