import 'dart:convert';
import 'dart:math';

import 'package:bantay_alertdraft/create_accountpages/authority_createaccountpage.dart';
import 'package:bantay_alertdraft/create_accountpages/authority_getstarted.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthorityVerificationPage extends StatefulWidget {
  final Map<String, dynamic> authorityData;
  final String email;

  const AuthorityVerificationPage({
    super.key,
    required this.authorityData,
    required this.email,
  });

  @override
  _AuthorityVerificationPageState createState() =>
      _AuthorityVerificationPageState();
}

class _AuthorityVerificationPageState extends State<AuthorityVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<bool> _isFilled = List.generate(6, (index) => false);

  int _timerSeconds = 300;
  late Timer _timer;
  bool _canResendCode = false;

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();
    _sendVerificationCode();
    _startTimer();
  }

  void _setupFocusListeners() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          _isFilled[i] = false;
          setState(() {});
        }
      });
    }
  }

  void _startTimer() {
    _timerSeconds = 300;
    _canResendCode = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        setState(() => _canResendCode = true);
        _timer.cancel();
      }
    });
  }

  String get formattedTime {
    final minutes = (_timerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _generateAlphanumericCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  Future<void> _sendVerificationCode() async {
    final code = _generateAlphanumericCode(6);
    final now = Timestamp.now();
    final expiresAt = Timestamp.fromDate(
      DateTime.now().add(const Duration(minutes: 5)),
    );

    try {
      await FirebaseFirestore.instance
          .collection('_email_verifications')
          .doc(widget.email)
          .set({'code': code, 'createdAt': now, 'expiresAt': expiresAt})
          .then((_) {
            print("✅ Code saved to Firestore: $code");
          });

      final emailPayload = {
        "smtpUser": "bantayalertapp03@gmail.com",
        "smtpPass": "djve dlhl ljkm imdw",
        "to": widget.email,
        "subject": "Your Bantay Alert Verification Code",
        "htmlBody": """
          <div style=\"font-family:Arial,sans-serif;line-height:1.6\">
            <h2>🔐 Email Verification Code</h2>
            <p>Hello <strong>${widget.authorityData['firstName']} ${widget.authorityData['lastName']}</strong>,</p>
            <p>Thank you for signing up with Bantay Alert(RESIDENT). Use the following code to verify your email:</p>
            <h1 style=\"letter-spacing:5px;text-align:center;\">$code</h1>
            <p>This code will expire in 5 minutes.</p>
          </div>
        """,
      };

      final response = await http.post(
        Uri.parse('https://premium-emailer.vercel.app/api/send-email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(emailPayload),
      );

      if (response.statusCode == 200) {
        print("📧 Email sent successfully");
      } else {
        print("❌ Email send failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending code: $e");
    }
  }

  void _resendCode() {
    if (!_canResendCode) return;
    _startTimer();
    _sendVerificationCode();
  }

  void _onKeyPressed(String value, int index) {
    if (value.isNotEmpty) {
      _controllers[index].text = value.toUpperCase();
      _isFilled[index] = true;

      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus(); // Remove focus on last field
      }
    } else {
      _isFilled[index] = false;
    }

    setState(() {});

    if (_isFilled.every((filled) => filled)) {
      Future.delayed(Duration(milliseconds: 100), () => _verifyCodeIfReady());
    }
  }

  void _verifyCodeIfReady() async {
    if (!_isFilled.every((filled) => filled)) return;
    final authoVar = Provider.of<AuthorityVariable>(context, listen: false);
    final enteredCode = _controllers.map((c) => c.text.toUpperCase()).join();

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('_email_verifications')
              .doc(widget.email)
              .get();
      final storedCode = doc.data()?['code']?.toString().toUpperCase();
      if (doc.exists && storedCode == enteredCode) {
        final authorityQuery =
            await FirebaseFirestore.instance
                .collection('_authorities')
                .where('email', isEqualTo: widget.email)
                .limit(1)
                .get();

        if (authorityQuery.docs.isNotEmpty) {
          //Clear input fields
          authoVar.firstNameController.clear();
          authoVar.lastNameController.clear();
          authoVar.middleInitController.clear();
          authoVar.selectedMonth = "";
          authoVar.dayController.clear();
          authoVar.yearController.clear();
          authoVar.selectedSex = "";
          authoVar.email = "";
          authoVar.newPasswordController.clear();
          authoVar.confirmPassController.clear();

          await FirebaseFirestore.instance
              .collection('_authorities')
              .doc(authorityQuery.docs.first.id)
              .update({'verified': true});

          await FirebaseFirestore.instance
              .collection('_email_verifications')
              .doc(widget.email)
              .delete();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthorityGetStartedPage()),
          );
        }
      } else {
        for (int i = 0; i < _controllers.length; i++) {
          _controllers[i].clear();
          _isFilled[i] = false;
        }
        FocusScope.of(context).requestFocus(_focusNodes[0]);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid verification code.")),
        );
      }
    } catch (e) {
      print('Error verifying code: $e');
    }
  }

  void _onBackspacePressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _handleBackNavigation() async {
    try {
      await FirebaseFirestore.instance
          .collection('_email_verifications')
          .doc(widget.email)
          .delete();
    } catch (e) {
      debugPrint('Failed to delete verification doc: $e');
    }

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthorityCreateAccountPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _handleBackNavigation,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              const Text.rich(
                TextSpan(
                  text: "Enter the verification code sent to your \n",
                  style: TextStyle(fontSize: 18),
                  children: [
                    TextSpan(
                      text: "email",
                      style: TextStyle(fontSize: 18, color: Color(0xFF7C0A20)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (event) => _onBackspacePressed(index, event),
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9]'),
                            ),
                            LengthLimitingTextInputFormatter(1),
                          ],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color:
                                _isFilled[index] ? Colors.black : Colors.grey,
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            _controllers[index]
                                .selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: _controllers[index].text.length,
                              ),
                            );
                          },
                          onChanged: (value) => _onKeyPressed(value, index),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFDBDBDB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Didn't get a code?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: _canResendCode ? _resendCode : null,
                      child: Text(
                        _canResendCode
                            ? "Get a new code"
                            : "Resend code in $formattedTime sec",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _canResendCode ? Color(0xFF7C0A20) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}

/// CONVERT INPUT TO CAPITALIZE
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upperCaseText = newValue.text.toUpperCase();

    return TextEditingValue(
      text: upperCaseText,
      selection: TextSelection.collapsed(offset: upperCaseText.length),
    );
  }
}
