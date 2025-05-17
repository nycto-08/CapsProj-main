import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:provider/provider.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final DateFormat formattedDateTime = DateFormat('yyyy-MM-dd – hh:mm a');
  List<Map<String, dynamic>> announcement = [];
  String? selectedIconPath;
  bool sortDescending = true;
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedAnnouncements = List.from(announcement);
    sortedAnnouncements.sort((a, b) {
      DateTime dateA =
          a['timestamp'] is String
              ? DateFormat('yyyy-MM-dd – hh:mm a').parse(a['timestamp'])
              : a['timestamp'];
      DateTime dateB =
          b['timestamp'] is String
              ? DateFormat('yyyy-MM-dd – hh:mm a').parse(b['timestamp'])
              : b['timestamp'];
      return sortDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: const Color(0xFF7C0A20),
                  pinned: false,
                  floating: false,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),

                  ),
                  title: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 30),
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
                            SizedBox(width: 25),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: isSelectionMode
                      ? [
                      IconButton(
                        onPressed: selectedIndexes.isEmpty
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Confirm Deletion"),
                                    content: const Text("Are you sure you want to delete the selection?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteSelectedAnnouncements();
                                        },
                                        child: const Text("Confirm", style: TextStyle(color: Color(0xFF7C0A20))),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        icon: const Icon(Icons.delete, color: Colors.white),
                      ),
                    ]
                  : [
                      IconButton(
                        onPressed: showCreateAnnouncementDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Consumer<AuthorityVariable>(
                    builder: (context, authorityVariable, _) {
                    List<Map<String, dynamic>> sortedAnnouncements = [...authorityVariable.filteredAnnouncements];

                    sortedAnnouncements.sort((a, b) {
                      final aTime = a['timestamp'] ?? DateTime.now();
                      final bTime = b['timestamp'] ?? DateTime.now();
                      return sortDescending ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
                    });

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
                      itemCount: sortedAnnouncements.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isSelectionMode)
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedIndexes.length == authorityVariable.announcement.length) {
                                        selectedIndexes.clear();
                                      } else {
                                        selectedIndexes = Set.from(
                                          List.generate(authorityVariable.announcement.length, (i) => i),
                                        );
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    selectedIndexes.length == authorityVariable.announcement.length
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: const Color(0xFF7C0A20),
                                  ),
                                  label: const Text(
                                    "Select All",
                                    style: TextStyle(fontSize: 14, color: Color(0xFF7C0A20)),
                                  ),
                                ),
                              const Spacer(),
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  setState(() {
                                    sortDescending = value == 'newest';
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
                                  const PopupMenuDivider(),
                                  PopupMenuItem<String>(
                                    enabled: false,
                                    child: Consumer<AuthorityVariable>(
                                      builder: (context, authorityVariable, _) {
                                        return StatefulBuilder(
                                          builder: (context, localSetState) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Filter by Audience',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                ),
                                                CheckboxListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text(
                                                    'All',
                                                    style: TextStyle(
                                                      color: authorityVariable.announcementChoice.contains("All")
                                                          ? Colors.black
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  value: authorityVariable.announcementChoice.contains("All"),
                                                  onChanged: (bool? value) {
                                                    authorityVariable.toggleChoice("All");
                                                    localSetState(() {});
                                                  },
                                                ),
                                                CheckboxListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text(
                                                    'Resident',
                                                    style: TextStyle(
                                                      color: authorityVariable.announcementChoice.contains("Resident")
                                                          ? Colors.black
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  value: authorityVariable.announcementChoice.contains("Resident"),
                                                  onChanged: (bool? value) {
                                                    authorityVariable.toggleChoice("Resident");
                                                    localSetState(() {});
                                                  },
                                                ),
                                                CheckboxListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text(
                                                    'Authority',
                                                    style: TextStyle(
                                                      color: authorityVariable.announcementChoice.contains("Authority")
                                                          ? Colors.black
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  value: authorityVariable.announcementChoice.contains("Authority"),
                                                  onChanged: (bool? value) {
                                                    authorityVariable.toggleChoice("Authority");
                                                    localSetState(() {});
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
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

                        final announceIndex = sortedAnnouncements[index - 1];
                        final originalIndex = authorityVariable.announcement.indexOf(announceIndex);
                        final isSelected = selectedIndexes.contains(originalIndex);

                        return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              isSelectionMode = true;
                              selectedIndexes.add(originalIndex);
                            });
                          },
                          onTap: () {
                            if (isSelectionMode) {
                              setState(() {
                                if (isSelected) {
                                  selectedIndexes.remove(originalIndex);
                                  if (selectedIndexes.isEmpty) isSelectionMode = false;
                                } else {
                                  selectedIndexes.add(originalIndex);
                                }
                              });
                            } else {
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
                                  actions: [
                                    Container(
                                      width: 80,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 8, bottom: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7C0A20),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Confirm Deletion"),
                                              content: const Text("Are you sure you want to delete this?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // close confirm dialog
                                                    deleteAnnouncement(originalIndex);
                                                  },
                                                  child: const Text("Confirm", style: TextStyle(color: Color(0xFF7C0A20))),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        tooltip: 'Delete',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Card(
                            color: isSelected ? Colors.red[100] : null,
                            margin: EdgeInsets.fromLTRB(8, index == 1 ? 0 : 8, 8, 8),
                            child: ListTile(
                              leading: isSelectionMode
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (checked) {
                                        setState(() {
                                          if (checked == true) {
                                            selectedIndexes.add(originalIndex);
                                          } else {
                                            selectedIndexes.remove(originalIndex);
                                            if (selectedIndexes.isEmpty) isSelectionMode = false;
                                          } 
                                        });
                                      },
                                      activeColor: const Color(0xFF7C0A20),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      radius: 20,
                                      child: Image.asset(
                                        (announceIndex['icon'] != null && announceIndex['icon'] != '')
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

                                      if (audienceList.contains("Resident") && audienceList.contains("Authority")) {
                                        return [
                                          Chip(
                                            label: const Text("Resident", style: TextStyle(fontSize: 13, color: Colors.white)),
                                            backgroundColor: const Color(0xFF414042),
                                            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          const SizedBox(width: 4),
                                          Chip(
                                            label: const Text("Authority", style: TextStyle(fontSize: 13, color: Colors.white)),
                                            backgroundColor: const Color(0xFFA31321),
                                            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ];
                                      } else {
                                        return audienceList.map<Widget>((aud) => Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Chip(
                                            label: Text(aud, style: const TextStyle(fontSize: 13, color: Colors.white)),
                                            backgroundColor: aud == "Authority"
                                                ? const Color(0xFFA31321)
                                                : aud == "Resident"
                                                    ? const Color(0xFF414042)
                                                    : const Color(0xFFF2F2F2),
                                            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        )).toList();
                                      }
                                    }(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        }

  void showCreateAnnouncementDialog() {
    selectedIconPath ??= "assets/dp_speaker.png";
    Provider.of<AuthorityVariable>(context, listen: false).clearData();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C0A20),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            headerContainerText(text: "CREATE NEW ANNOUNCEMENT"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            Consumer<AuthorityVariable>(
                              builder: (context, authorityVariable, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Dropdown Button with Checkboxes
                                    StatefulBuilder(
                                      builder: (BuildContext context, StateSetter localSetState) {
                                        return DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: null,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          hint: Text(
                                            authorityVariable.announcementChoice.contains("All")
                                                ? "All"
                                                : (authorityVariable.announcementChoice.isEmpty
                                                    ? "Who is this for?"
                                                    : authorityVariable.announcementChoice.join(', ')),
                                            style: const TextStyle(fontSize: 14, color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          items: authorityVariable.announcementChoiceList.map((String choice) {
                                            return DropdownMenuItem<String>(
                                              value: choice,
                                              enabled: false,
                                              child: Consumer<AuthorityVariable>(
                                                builder: (context, authorityVariable, _) {
                                                  return InkWell(
                                                    onTap: () {
                                                      authorityVariable.toggleSelectionOnly(choice);
                                                      localSetState(() {}); // Rebuild dropdown
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 10),
                                                        Checkbox(
                                                          value: authorityVariable.announcementChoice.contains(choice),
                                                          onChanged: (_) {
                                                            authorityVariable.toggleSelectionOnly(choice);
                                                            localSetState(() {}); // Rebuild dropdown
                                                          },
                                                        ),
                                                        Expanded(child: Text(choice)),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (_) {}, 
                                          validator: (value) {
                                            if (authorityVariable.announcementChoice.isEmpty) {
                                              return 'Please select at least one.';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF2F2F2),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust this
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showIconPicker((picked) {
                                      setDialogState(() {
                                        selectedIconPath = picked;
                                      });
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.grey[200],
                                    child: selectedIconPath != null
                                        ? Image.asset(
                                            selectedIconPath!,
                                            width: 48,
                                            height: 48,
                                          )
                                        : Image.asset(
                                            'assets/dp_speaker.png',
                                            width: 48,
                                            height: 48,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded( 
                                  child: Consumer<AuthorityVariable>(
                                    builder: (context, authorityVariable, child) {
                                      bool isFocused = authorityVariable.titleAnnouncementFocusNode.hasFocus;
                                      return TextFormField(
                                        controller: authorityVariable.titleAnnouncementController,
                                        focusNode: authorityVariable.titleAnnouncementFocusNode,
                                        autofocus: true,
                                        textCapitalization: TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          labelText: "Title",
                                          labelStyle: TextStyle(
                                            color: isFocused ? Color(0xFF7C0A20) : Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF2F2F2),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 12,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF7C0A20),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'This field cannot be empty.';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            authorityVariable.titleAnnouncementController.clear();
                                            authorityVariable.title = "";
                                          } else {
                                            final upper = value.toUpperCase();
                                            if (value != upper) {
                                              authorityVariable.titleAnnouncementController.value =
                                                  authorityVariable.titleAnnouncementController.value.copyWith(
                                                text: upper,
                                                selection: TextSelection.collapsed(offset: upper.length),
                                              );
                                            }
                                            authorityVariable.title = upper;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            
                            Consumer<AuthorityVariable>(
                              builder: (context, authorityVariable, child) {
                                bool isFocused = authorityVariable.contentAnnouncementFocusNode.hasFocus;
                                return TextFormField(
                                  controller: authorityVariable.contentAnnouncementController,
                                  focusNode: authorityVariable.contentAnnouncementFocusNode,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    labelText: "Content",
                                    labelStyle: TextStyle(
                                      color: isFocused ? Color(0xFF7C0A20) : Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF2F2F2),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF7C0A20),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  maxLines: 4,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field cannot be empty.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if(value.isEmpty) {
                                      authorityVariable.contentAnnouncementController.clear();
                                      authorityVariable.content = "";
                                    }
                                    else {
                                      authorityVariable.content = value;
                                    }
                                  },
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
              actions: [
                Consumer<AuthorityVariable>(
                  builder: (context, authorityVariable, child) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        authorityVariable.clearData(); // Clears all fields
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    );
                  },
                ),
                Consumer<AuthorityVariable>(
                  builder: (context, authorityVariable, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C0A20),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final title = authorityVariable.titleAnnouncementController.text.trim(); 
                          final content = authorityVariable.contentAnnouncementController.text.trim();
                          final targetAudience = authorityVariable.announcementChoice.contains("All")
                              ? ["Resident", "Authority"]
                              : List<String>.from(authorityVariable.announcementChoice);

                          setState(() {
                            announcement.add({
                              'title': title,
                              'content': content,
                              'icon': selectedIconPath,
                              'timestamp': DateTime.now(),
                              'audience': targetAudience,
                            });
                          });

                          authorityVariable.setAnnouncements([...announcement]);
                          authorityVariable.filterAnnouncements();

                          authorityVariable.clearData(); 
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Post"),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showIconPicker(Function(String) onIconPicked) {
    final icons = [
      'assets/dp_speaker.png',
      'assets/dp_CalEvent.png',
      'assets/dp_trash.png',
      'assets/dp_fire.png',
      'assets/dp_noElectric.png',
      'assets/dp_warning.png',
    ];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AAE1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [headerIconContainerText(text: "SELECT ICON")],
                ),
              ),

              // Grid of icons
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: icons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onIconPicked(icons[index]);
                      },
                      child: Image.asset(icons[index], width: 48, height: 48),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteAnnouncement(int index) {
    setState(() {
      announcement.removeAt(index);
    });
    Navigator.of(context).pop();
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

  void deleteSelectedAnnouncements() {
    setState(() {
      final toRemove = selectedIndexes.toList()..sort((b, a) => a.compareTo(b));
      for (var index in toRemove) {
        announcement.removeAt(index);
      }
      selectedIndexes.clear();
      isSelectionMode = false;
    });
  }


  Widget headerDialogText({
    required String text,
    Color color = Colors.white,
    double fontSize = 30,
    String fontFamily = 'CascadiaCodeBold',
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget headerIconContainerText({
    required String text,
    Color color = Colors.white,
    double fontSize = 20,
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
