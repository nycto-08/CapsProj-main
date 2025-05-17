import 'package:bantay_alertdraft/login_pages/authority_loginpage.dart';
import 'package:bantay_alertdraft/login_pages/resident_loginpage.dart';
import 'package:flutter/material.dart';

class HomeRolePage extends StatelessWidget {
  const HomeRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.1;

    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Center(
                  child: Image.asset(
                    'assets/bantay_logo.png',
                    width: size.width * 0.8,
                  ),
                ),
                Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResidentLoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF414042),
                      minimumSize: Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'RESIDENT',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthorityLoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA31321),
                      minimumSize: Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'AUTHORITY',
                      style: TextStyle(
                        fontFamily: 'Montserrat', 
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
