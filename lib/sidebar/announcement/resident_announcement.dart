import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ResidentAnnouncement extends StatefulWidget {
  const ResidentAnnouncement({super.key});

  @override
  _ResidentAnnouncementState createState() => _ResidentAnnouncementState();
}

class _ResidentAnnouncementState extends State<ResidentAnnouncement> {
  final DateFormat formattedDateTime = DateFormat('yyyy-MM-dd - hh: mm: a');

  Set<int> selectedIndexes = {};
  bool sortDescending = true;
  List<Map<String, dynamic>> announcement = [];
  @override
  Widget build(BuildContext context) {


    List<Map<String, dynamic>> sortedAnnouncements = List.from(announcement);
    sortedAnnouncements.sort((a, b) {
        DateTime dateA = 
            a['timestamp'] is String   
                ? DateFormat('yyyy-MM-dd - hh:mm a').parse(a['timestamp'])
                : a['timestamp'];
        DateTime dateB = 
            b['timestamp'] is String
                ? DateFormat('yyyy-MM-dd - hh:mm a').parse(b['timestamp'])
                : b['timestamp'];
        return sortDescending ?  dateB.compareTo(dateA) : dateA.compareTo(dateB);
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
                                    'assets/icon_announcement.png',
                                    color: Colors.white,
                                    height: 16,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "ANNOUNCEMENTS",
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
                body: announcement.isEmpty
                ? Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Image.asset(
                                'assets/bg_no_announcement.png',
                                width: 250,
                                height: 250,
                                fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                                "NO ANNOUNCEMENT POSTED",
                                style: TextStyle(
                                    fontFamily: "RobotoBold",
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                ),  
                            ),
                        ],
                    ),
                )
                : Consumer<AuthorityVariable>(
                    builder: (context, authorityVariable, _) {
                        List<Map<String, dynamic>> sortedAnnouncement = [...authorityVariable.filteredAnnouncements];

                        sortedAnnouncement.sort((a, b) {
                            final aTime = a['timestamp'] ?? DateTime.now();
                            final bTime = b['timestamp'] ?? DateTime.now();
                            return sortDescending ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
                        });
                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
                        itemCount: sortedAnnouncement.length + 1,    
                        itemBuilder: (context, index) {
                            if (index == 0) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        PopupMenuButton<String>(
                                            onSelected: (String value) {
                                                setState(() {
                                                sortDescending = value == "newest";
                                                });
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                const PopupMenuItem<String>(
                                                    value: 'newest',
                                                    child: Text('Sort Newest to Oldest'),
                                                ),
                                                const PopupMenuItem<String>(
                                                    value: 'oldest',
                                                    child: Text('Sort Oldest to Newest'),
                                                ),
                                            ],
                                            child: TextButton.icon(
                                                icon: const Icon(Icons.sort),
                                                label: const Text(
                                                    "Sort By",
                                                    style: TextStyle(fontSize: 14),
                                                ),
                                                onPressed: null, 
                                            ),
                                        ),
                                    ],
                                );
                            }

                            final announceIndex = sortedAnnouncement[index - 1];

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
                                                                child: Text(
                                                                    announceIndex['title'] ?? '',
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                        Padding(
                                                            padding: const EdgeInsets.all(16),
                                                            child: Container(
                                                                width: double.infinity,
                                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(color: Colors.black, width: 1),
                                                                ),
                                                                child: Text(
                                                                    announceIndex['content'] ?? '',
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),      
                                        ),
                                    );
                                },
                                child: Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: ListTile(
                                        leading: CircleAvatar(
                                            backgroundColor: Colors.grey[200],
                                            radius: 20,
                                            child: Image.asset(
                                                (announceIndex['icon'] != null && announceIndex['index'] != '')
                                                    ? announceIndex['icon']
                                                    : "assets/dp_speaker.png",
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.contain,
                                            ),
                                        ),
                                    title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: Text(
                                                  announceIndex['title'] ?? '',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xFF7C0A20),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'CascadiaCodeBold',
                                                  ),
                                                ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                                formattedDateTime.format(announceIndex['timestamp']),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                ),  
                                            ),
                                        ],
                                    ),
                                    subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            Expanded(
                                                child: Text(
                                                  announceIndex['content'] ?? '',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                            ),
                                            const SizedBox(width: 8),
                                            Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: () {
                                                final List audienceList = announceIndex['audience'] ?? [];      
                                                return audienceList.where((aud) => aud == "Resident") .map<Widget>((aud) => Padding(
                                                padding: const EdgeInsets.only(right: 4.0),
                                                child: Chip(
                                                    label: Text("Resident", style: const TextStyle(fontSize: 13, color: Colors.white)),
                                                    backgroundColor: const Color(0xFF414042),
                                                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                )).toList();
                                                }(),
                                            ),
                                        ],
                                    ),
                                    ),
                                ),
                            );                            
                        }
                    );
                },
                ),
            ),
        ),
    );
  }
}
