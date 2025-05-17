import 'package:flutter/material.dart';

//FrontDialog
Future<bool> showFrontCustomDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFA31321), width: 5),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "VALID I.D.",
                style: TextStyle(
                  color: Color(0xFFA31321),
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoBold',
                  ),
              ),
              SizedBox(height: 10),
              Text(
                "Tips on how your photo should look",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'MyriadProRegular',
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/wrong_id_corner.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Must show all \nfour corners",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'MyriadProRegular',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true  ,
                      ),

                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Image.asset(
                        "assets/wrong_id_blur.png",
                        width:100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Must not be \ncropped/blurry",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'MyriadProRegular'
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
               SizedBox(height: 5),
              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/wrong_id_covered.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Must not be \ncovered in any way",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'MyriadProRegular',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true  ,
                      ),

                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Image.asset(
                        "assets/right_id.png",
                        width:100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "This is \nright!",
                        style: TextStyle(
                          color: Color(0xFF00a651),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyriadProRegular'
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE5E5),
                      border: Border.all(color: Color(0xFFA31321), width: 2), // Border color and width
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return true if confirmed
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside the button
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                            color: Color(0xFFA31321), // Text color
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  ) ?? false; 
}

//BackDialog
Future<bool> showBackCustomDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFA31321), width: 5),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "VALID I.D.",
                style: TextStyle(
                  color: Color(0xFFA31321),
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoBold',
                  ),
              ),
              SizedBox(height: 10),
              Text(
                "Tips on how your photo should look",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'MyriadProRegular',
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/wrongB_id_corner.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Must show all \nfour corners",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'MyriadProRegular',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true  ,
                      ),

                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Image.asset(
                        "assets/wrongB_id_blur.png",
                        width:100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Must not be \ncropped/blurry",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'MyriadProRegular'
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
               SizedBox(height: 5),
              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/wrongB_id_covered.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Must not be \ncovered in any way",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'MyriadProRegular',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true  ,
                      ),

                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Image.asset(
                        "assets/rightB_id.png",
                        width:100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "This is \nright!",
                        style: TextStyle(
                          color: Color(0xFF00a651),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyriadProRegular'
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE5E5),
                      border: Border.all(color: Color(0xFFA31321), width: 2), // Border color and width
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return true if confirmed
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside the button
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                            color: Color(0xFFA31321), // Text color
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  ) ?? false; 





  
}