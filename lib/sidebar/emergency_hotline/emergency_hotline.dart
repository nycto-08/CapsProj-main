import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyHotline extends StatefulWidget {
  const EmergencyHotline({super.key});

  @override
  _EmergencyHotlineState createState() => _EmergencyHotlineState();
}

class _EmergencyHotlineState extends State<EmergencyHotline>{
  List <Map<String, dynamic>> emergencyHotline = [
    {
      'title': 'Fire',
      'phoneNumber': '9523314211'
    }
  ];
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    List <Map <String, dynamic>> sortedEmergencyHotline = List.from(emergencyHotline);
    sortedEmergencyHotline.sort((a, b){
      return (a['title'] ?? '').toString().toLowerCase().compareTo((b['title'] ?? '').toString().toLowerCase());
    });

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
    child: Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxisScrolled) => [
          SliverAppBar(
            backgroundColor: const Color(0xFF7C0A20),
            pinned: false,
            floating: false,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icon_call.png',
                  color: Colors.white,
                  height: 16,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "EMERGENCY HOTLINE",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
        ], 
        body: emergencyHotline.isEmpty
          ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/bg_no_hotline.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  "NO EMERGENCY HOTLINE AVAILABLE",
                  style: TextStyle(
                    fontFamily: 'RobotoBold',
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
          : ListView.builder(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            itemCount: sortedEmergencyHotline.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox.shrink(); // or return some optional header
              }
              final hotlineIndex = sortedEmergencyHotline[index - 1];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (_) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF7C0A20),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              ),
                              child: Center(
                                child: headerContainerText(text: hotlineIndex['title'] ?? ''),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '+63${hotlineIndex['phoneNumber'] ?? ''}',
                                    style: const TextStyle(fontSize: 24, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Center(
                          child: IconButton(
                            onPressed: () async {
                              final phoneNumberData = hotlineIndex['phoneNumber'] ?? '';
                              final formattedPhoneNumberData = phoneNumberData.replaceAll(RegExp(r'[^0-9]'), '');
                              final Uri telUri = Uri.parse('tel: +63$formattedPhoneNumberData');

                              if(formattedPhoneNumberData.isEmpty) {
                                debugPrint('Phone number is empty or invalid');
                                return;
                              }

                              try {
                                final launched = await launchUrl(telUri, mode: LaunchMode.externalApplication);
                                if(!launched) {
                                  debugPrint('Could not launch dialer');
                                }  
                              } catch (e) {
                                debugPrint('Exception launching dialer: $e');
                              }
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00A651),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icon_call.png',
                                width: 18,
                                height: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  elevation: 0,
                  child: ListTile(
                    title: Expanded(
                      child: Text(
                        hotlineIndex['title'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF7C0A20),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CascadiaCodeBold',
                        ),
                      ),
                    ),
                    subtitle: Text(
                      '+63${hotlineIndex['phoneNumber'] ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final phoneNumberData = hotlineIndex['phoneNumber'] ?? '';
                        final formattedPhoneNumberData = phoneNumberData.replaceAll(RegExp(r'[^0-9]'), '');
                        final Uri telUri = Uri.parse('tel: +63$formattedPhoneNumberData');

                        if(formattedPhoneNumberData.isEmpty) {
                          debugPrint('Phone number is empty or invalid');
                          return;
                        }

                        try {
                          final launched = await launchUrl(telUri, mode: LaunchMode.externalApplication);
                          if(!launched) {
                            debugPrint('Could not launch dialer');
                          }  
                        } catch (e) {
                          debugPrint('Exception launching dialer: $e');
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A651),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icon_call.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ),
    ),
    );
  }

  Widget headerContainerText({
    required String text,
    Color color = Colors.white,
    double fontSize = 15,
    String fontFamily = 'Montserrat',
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

}
