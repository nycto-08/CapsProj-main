import 'package:bantay_alertdraft/sidebar/barangay_sidebar/approval_card/authority_approval_card.dart';
import 'package:bantay_alertdraft/sidebar/barangay_sidebar/list/authorities_list_card.dart';
import 'package:flutter/material.dart';

class AuthorityApprovalList extends StatefulWidget {
  const AuthorityApprovalList({super.key});

  @override
  _AuthorityApprovalListState createState() => _AuthorityApprovalListState();
}

class _AuthorityApprovalListState extends State<AuthorityApprovalList> {
  bool showSearch = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: const Color(0xFF7C0A20),
                  pinned: false,
                  floating: false,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 30),
                            Image.asset('assets/icon_autho.png', height: 16),
                            const SizedBox(width: 8),
                            const Text(
                              "AUTHORITIES",
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
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        //TO-DO
                      },
                    ),
                  ],
                ),
              ],
          body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    if(showSearch)
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.grey.shade200,
                        child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                hintText: 'Search authorities...',
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                        searchController.clear();
                                    },
                                )
                                :  null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                ),
                            ),
                            onChanged: (value) {
                                setState(() {
                                  //Trigger
                                });
                                //Live Search TO-DO
                            },
                        ),
                    ),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.center,
                        child: Column(
                            children: [
                                headerContainer(
                                  context: context,
                                  child: Center(
                                    child: headerContainerText(text: "AUTHORITY REQUEST"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                waitingForApprovalProfileCard(
                                    profileImagePath: 'assets/profile.png',
                                    name: 'John Deqweqwewqoe',
                                    employeeNo: '2021-0212',
                                    address: '123 Barangay St.',
                                    contactNumber: '09123456789',
                                    status: 'Waiting for Approval',
                                    onAccept: () {
                                        //Handle accept action
                                    },
                                    onReject: () {
                                        // Handle reject action
                                    },
                                    onViewProfile: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => AuthorityApprovalCard(),
                                        )
                                      );
                                    },
                                ),
                                SizedBox(height: 10),
                                headerContainer(
                                  context: context,
                                  color: Color(0xFFBE1E2D),
                                  child: Center(
                                    child: headerContainerText(text: "AUTHORITIES"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                authorityProfileCard(
                                    profileImagePath: 'assets/profile.png',
                                    name: 'John Deqweqwewqoe',
                                    employeeNo: '2021-104',
                                    address: '123 Barangay St.',
                                    contactNumber: '09123456789',
                                    status: 'Waiting for Approval',
                                    onViewProfile: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => AuthorityListCard(),
                                        )
                                      );
                                    },
                                ),
                            ],
                        ),
                    ),
                ],
            ),
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

  Widget headerContainer({
    required BuildContext context,
    required Widget child,
    double? width,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 3,
    ),
    Color color = const Color(0xFF7C0A20),
    double borderRadius = 10.0,
  }) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  Widget waitingForApprovalProfileCard({
    required String profileImagePath,
    required String name,
    required String employeeNo,
    required String address,
    required String contactNumber,
    required String status,
    required VoidCallback onAccept,
    required VoidCallback onReject,
    required VoidCallback onViewProfile,
  }) {
    return InkWell(
      onTap: onViewProfile,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: Row(
          children: [
            SizedBox(width: 16),
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(profileImagePath),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    employeeNo,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Montserrat',
                        overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    contactNumber,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(size: 50, Icons.check_circle, color: Colors.green),
                  onPressed: onAccept,
                ),
                IconButton(
                  icon: Icon(size: 50, Icons.cancel, color: Colors.red),
                  onPressed: onReject,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget authorityProfileCard({
    required String profileImagePath,
    required String name,
    required String address,
    required String employeeNo,
    required String contactNumber,
    required String status,
    required VoidCallback onViewProfile,
    VoidCallback? onOptions,
  }) {
    return InkWell(
      onTap: onViewProfile,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: Row(
          children: [
            SizedBox(width: 16),
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(profileImagePath),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    employeeNo,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    contactNumber,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, color: Colors.black),
              onSelected: (String value) {
                if (onOptions != null) {
                  onOptions();
                }
              },
              itemBuilder:
                (BuildContext context) => [
                PopupMenuItem(value: "view", child: Text("View")),
                ],
            ),
          ],
        ),
      ),
    );
  }
}
