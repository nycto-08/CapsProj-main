import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateEmergencyHotline extends StatefulWidget {
  const CreateEmergencyHotline({super.key});

  @override
  _CreateEmergencyHotlineState createState() => _CreateEmergencyHotlineState();
}

class _CreateEmergencyHotlineState extends State<CreateEmergencyHotline> {
  List <Map<String, dynamic>> emergencyHotline = [];
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    List <Map <String, dynamic>> sortedEmergencyHotline = List.from(emergencyHotline);
    sortedEmergencyHotline.sort((a, b) {
      return (a['title'] ?? '').toString().toLowerCase().
        compareTo((b['title'] ?? '').toString().toLowerCase());
    });

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    child: Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxisScrolled) => [
              SliverAppBar(
                backgroundColor: const Color(0xFF7C0A20),
                pinned: false,
                floating: false,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  deleteSelectedEmergencyHotline();
                                }, 
                                child: const Text("Confirm", style: TextStyle(color: Color(0xFF7C0A20))),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                    )
                  ]
                : [  
                    IconButton(
                      onPressed: showCreateEmergencyHotlineDialog,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
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
                  fontWeight: FontWeight.w500,
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(isSelectionMode)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          if(selectedIndexes.length == emergencyHotline.length) {
                            selectedIndexes.clear();
                          } else {
                            selectedIndexes = Set.from(List.generate(emergencyHotline.length, (i) => i));
                          }
                        });
                      },
                      icon: Icon(
                        selectedIndexes.length == emergencyHotline.length
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                        color: const Color(0xFF7C0A20),
                      ),
                      label: const Text(
                        "Select All",
                        style: TextStyle(fontSize: 14, color: Color(0xFF7C0A20)),
                      ),
                    ),
                  ],
                );
              }

              final hotlineIndex = sortedEmergencyHotline[index - 1];
              final originalIndex = emergencyHotline.indexOf(hotlineIndex);
              final isSelected = selectedIndexes.contains(originalIndex);

              return GestureDetector(
                onLongPress: (){
                  setState(() {
                    isSelectionMode = true;
                    selectedIndexes.add(originalIndex);
                  });
                },

                onTap: () {
                  if (isSelectionMode) {
                    setState(() {
                      if(isSelected) {
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
                                  child: headerDialogText(text: hotlineIndex['title'] ?? ''),
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
                        actions:[
                        Center(
                          child: IconButton(
                            onPressed: () async {
                              final phoneNumberData = hotlineIndex['phoneNumber'] ?? '';
                              final formattedPhoneNumberData = phoneNumberData.replaceAll(RegExp(r'[^0-9]'), '');
                              final Uri telUri = Uri.parse('tel:+63$formattedPhoneNumberData');

                              if (formattedPhoneNumberData.isEmpty) {
                                debugPrint('Phone number is empty or invalid');
                                return;
                              }

                              try {
                                final launched = await launchUrl(telUri, mode: LaunchMode.externalApplication);
                                if (!launched) {
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
                  }
                },

                child: Card(
                  color: isSelected ? Colors.red[100] : null,
                  margin: EdgeInsets.fromLTRB(8, index == 1 ? 0 : 8, 8, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: isSelectionMode ? BorderRadius.circular(8) : BorderRadius.circular(3),
                    side: BorderSide(
                      color: isSelectionMode ? Color(0xFF7C0A20) : Colors.black,
                      width: 1,
                    ),
                  ),
                  elevation: isSelectionMode ? 3 : 0,
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
                              if(selectedIndexes.isEmpty) isSelectionMode = false;
                            }    
                          });
                        },
                        activeColor: const Color(0xFF7C0A20),
                      )
                      : null,
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
                        final Uri telUri = Uri.parse('tel:+63$formattedPhoneNumberData');

                        if (formattedPhoneNumberData.isEmpty) {
                          debugPrint('Phone number is empty or invalid');
                          return;
                        }

                        try {
                          final launched = await launchUrl(telUri, mode: LaunchMode.externalApplication);
                          if (!launched) {
                            debugPrint('Could not launch dialer');
                          }
                        } catch (e) {
                          debugPrint('Exception launching dialer: $e');
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A651),
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

  void showCreateEmergencyHotlineDialog() {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: headerContainerText(text: "CREATE NEW EMERGENCY HOTLINE", fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Consumer<AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        bool isFocused = authorityVariable.emergencyHotlineTitleFocusNode.hasFocus;
                        return TextFormField(
                          controller: authorityVariable.emergencyHotlineTitleController,
                          focusNode: authorityVariable.emergencyHotlineTitleFocusNode,
                          autofocus: true,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: "Emergency Hotline Title",
                            labelStyle: TextStyle(
                              color: isFocused ? const Color(0xFF7C0A20) : Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF2F2F2),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
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
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            final upper = value.toUpperCase();
                            if (value != upper) {
                              authorityVariable.emergencyHotlineTitleController.value =
                                  authorityVariable.emergencyHotlineTitleController.value.copyWith(
                                text: upper,
                                selection: TextSelection.collapsed(offset: upper.length),
                              );
                            }
                            authorityVariable.emergencyHotlineTitle = upper;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Consumer<AuthorityVariable>(
                      builder: (context, authorityVariable, child) {
                        bool isFocused = authorityVariable.emergencyHotlinePhoneNumberFocusNode.hasFocus;

                        return TextFormField(
                          controller: authorityVariable.emergencyHotlinePhoneNumberTextController,
                          focusNode: authorityVariable.emergencyHotlinePhoneNumberFocusNode,
                          keyboardType: TextInputType.phone,
                          //Phone Input Format
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                          decoration: InputDecoration(
                            labelText: "Emergency Number",
                            labelStyle: TextStyle(
                              color: isFocused ? const Color(0xFF7C0A20) : Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '+63',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                            filled: true,
                            fillColor: const Color(0xFFF2F2F2),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            border: OutlineInputBorder(
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
                            final phone = value.trim();
                            final regExp = RegExp(r'^(9\d{9})$');
                            
                            if (!regExp.hasMatch(phone)) {
                              return 'Enter a valid phone number.';
                            }
                            return null;
                          },
                        );
                      },
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
                    authorityVariable.clearData();
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
                      final title = authorityVariable.emergencyHotlineTitleController.text.trim();
                      final phoneNumber = authorityVariable.emergencyHotlinePhoneNumberTextController.text.trim();

                      setState(() {
                        emergencyHotline.add({
                          'title': title,
                          'phoneNumber' : phoneNumber,
                        });
                      });

                      authorityVariable.clearData();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save"),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void deleteEmergencyHotline(int index) {
    setState(() {
      emergencyHotline.removeAt(index);
    });
    Navigator.of(context).pop();
  }

  void deleteSelectedEmergencyHotline() {
    setState(() {
      final toRemove = selectedIndexes.toList()..sort((b, a) => a.compareTo(b));
      for (var index in toRemove) {
        emergencyHotline.removeAt(index);
      }
      selectedIndexes.clear();
      isSelectionMode = false;
    });
  }
}
