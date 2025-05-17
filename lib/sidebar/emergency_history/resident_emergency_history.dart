import 'package:flutter/material.dart';

class ResidentEmergencyHistory extends StatefulWidget {
  const ResidentEmergencyHistory({super.key});

  @override
  _ResidentEmergencyHistoryState createState() => _ResidentEmergencyHistoryState();
}

class _ResidentEmergencyHistoryState extends State<ResidentEmergencyHistory> {
  String? tappedCategory;
  String selectedCategory = "MEDICAL";
  final List<String> categories = ["MEDICAL", "AMBULANCE", "FIRE STATION", "POLICE", "BARANGAY PERSONNEL"];
  bool showDropdown = false;

  // Simulated history data (can be replaced with actual data from Firebase or elsewhere)
  List<Map<String, String>> historyData = [
     {
     "profile": "assets/profile.png",
     "name": "Juan Dela Cruz",
     "dateTime": "2025-04-17 | 12:00 PM",
     "status": "Responded",
     "category": "BARANGAY PERSONNEL",
    },
    
    {
     "profile": "assets/profile.png",
     "name": "Juan Dela Cruz",
     "dateTime": "2025-04-17 | 12:00 PM",
     "status": "Fake Report",
     "category": "MEDICAL",
    },

    {
     "profile": "assets/profile.png",
     "name": "Juan Dela Cruz",
     "dateTime": "2025-04-17 | 12:00 PM",
     "status": "Requested",
     "category": "BARANGAY PERSONNEL",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredData =
        historyData
            .where((item) => item["category"] == selectedCategory)
            .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          showDropdown = false;
        });
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
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
                        'assets/icon_history.png',
                        color: Colors.white,
                        height: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "HISTORY",
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
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    filteredData.isEmpty
                        ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: const Center(
                            child: Text(
                              "No record found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        )
                        : Column(
                          children:
                              filteredData.map((item) {
                                return historyCard(
                                  profileImagePath: item["profile"]!,
                                  name: item["name"]!,
                                  dateTime: item["dateTime"]!,
                                  status: item["status"]!,
                                  onView: () {
                                    // Handle tap
                                  },
                                );
                              }).toList(),
                        ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        emergencyContainer(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showDropdown = !showDropdown;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    selectedCategory,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ), 
                                Icon(
                                  showDropdown
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (showDropdown)
                          Container(
                            width: 395,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              border: Border.all(
                                color: const Color(0xFF7C0A20),
                              ),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: categories.map(
                                (category) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tappedCategory = category;
                                      selectedCategory = category;
                                      showDropdown = false;
                                    });
                                  },
                                  onTapDown: (_) {
                                    setState(() {
                                      tappedCategory = category;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      tappedCategory = null;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      tappedCategory = null;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        category,
                                        style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: selectedCategory == category
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: (selectedCategory == category || tappedCategory == category)
                                            ? const Color(0xFF7C0A20)
                                            : Colors.black,
                                        ),
                                      ),
                                      trailing: selectedCategory == category
                                          ? const Icon(Icons.check, color: Color(0xFF7C0A20), size: 18)
                                          : null,
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emergencyContainer({
    required Widget child,
    double width = 395,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    ),
    Color color = const Color(0xFF7C0A20),
    double borderRadius = 10.0,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
          bottom: Radius.circular(showDropdown ? 0 : borderRadius),
        ),
      ),
      child: child,
    );
  }

  Widget historyCard({
    required String profileImagePath,
    required String name,
    required String dateTime,
    required String status,
    required VoidCallback onView,
  }) {
    return InkWell(
      onTap: onView,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: Row(
          children: [
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(profileImagePath),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF7C0A20),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    dateTime,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: status == 'Responded' ? Color(0xFF00A651) 
                                                   : status == "Requested" 
                                                   ? Color(0xFFFF860A)  : Color(0xFFBE1E2D), 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
