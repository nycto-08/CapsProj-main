import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthorityVariable extends ChangeNotifier {
  //FOR DATABASE
  bool isCityBarangayLoading = false;
  Map<String, List<String>> cityToBarangayMap = {};

  void setEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  Future<void> initializeCityBarangay() async {
    isCityBarangayLoading = true;
    notifyListeners();

    await loadCityToBarangayMap();

    selectedCityProvince = '';
    availableBarangays = [];
    selectedBarangay = '';

    isCityBarangayLoading = false;
    notifyListeners();
  }

  Future<void> loadCityToBarangayMap() async {
    final firestore = FirebaseFirestore.instance;
    final cityStore = await firestore.collection('city').get();

    final Map<String, List<String>> result = {};

    for (var cityDoc in cityStore.docs) {
      final cityName = cityDoc.data()['name'] ?? cityDoc.id;

      final barangayStore =
          await cityDoc.reference.collection('barangay').get();
      final barangayList =
          barangayStore.docs
              .map((doc) => doc.data()['name']?.toString() ?? doc.id)
              .toList();

      result[cityName] = barangayList;
    }

    cityToBarangayMap = result;
    notifyListeners();
  }

  //Personal Information DATABASE
  String employeeNumber = "";
  String get getEmployeeNumber => employeeNumber;
  String firstName = "Jerm";
  String get getFirstName => firstName;
  String lastName = "Gonza";
  String get getLastName => lastName;
  String middleInitial = "A";
  String get getMiddleInitial => middleInitial;
  int age = 0;
  int get getAge => age;
  String month = "January";
  String get getMonth => month;
  int day = 1;
  int get getDay => day;
  int year = 1900;
  int get getYear => year;
  String sex = "M";
  String get getSex => sex;
  String civilStatus = "Single";
  String get getCivilStatus => civilStatus;
  String bloodType = "0+";
  String get getBloodType => bloodType;
  String phoneNumber = "9123456788";
  String get getPhoneNumber => phoneNumber;

  //Personal Address DATABASE
  String houseBlock = "Block St.";
  String get getHouseBlock => houseBlock;
  String cityProvince = "Malolos, Bulacan";
  String get getCityProvince => cityProvince;
  String barangay = "";
  String get getBarangay => barangay;

  //Emergency Contact DATABASE
  String nameEmergency = "Who";
  String get getNameEmergency => nameEmergency;
  String lastEmergency = "ever";
  String get getLastEmergency => lastEmergency;
  String middleEmergency = "the";
  String get getMiddleEmergency => middleEmergency;
  String relationshipEmergency = "person";
  String get getRelationshipEmergency => relationshipEmergency;
  String phoneNumberEmergency = "is0";
  String get getPhoneNumberEmergency => phoneNumberEmergency;

  //Emergency Address DATABASE
  String houseBlockEmergency = "Broadway";
  String get getHouseBlockEmergency => houseBlockEmergency;
  String cityProvinceEmergency = "New jersey";
  String get getCityProvinceEmergency => cityProvinceEmergency;
  String barangayEmergency = "weqeqw";
  String get getBarangayEmergency => barangayEmergency;

  //Account DATABASE
  String email = "";
  String get getEmail => email;

  //Announcement
  String title = "";
  String get getTitle => title;
  String content = "";
  String get getContent => content;

  //Emergency Hotline
  String emergencyHotlineTitle = "";
  String get getEmergencyHotlineTitle => emergencyHotlineTitle;

  //PROFILE IMAGE
  File? profileImage;
  String profileImagePath = "";
  File? get getProfileImage => profileImage;

  //FRONT IMAGE
  File? idFrontImage;
  String idFrontImagePath = "";

  //BACK IMAGE
  File? idBackImage;
  String idBackImagePath = "";

  //Other int
  int? selectedAge;
  int selectedDay = 1;
  int notificationCount = 0;

  //RoleSwitch
  bool medicalSwitch = false;
  bool ambulanceSwitch = false;
  bool fireStationSwitch = false;
  bool policeSwitch = false;
  bool barangayPersonnelSwitch = false;

  List<String> announcementChoice = [];
  List<String> announcementChoiceList = ['All', 'Resident', 'Authority'];
  List<String> audienceFilter = ['All'];

  List<Map<String, dynamic>> announcement = [];
  List<Map<String, dynamic>> filteredAnnouncements = [];

  //Text Controllers
  //Employee Number
  final TextEditingController employeeNumberController =
      TextEditingController();
  //Personal Information Controller
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleInitController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController civilStatusController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  //Personal Address Controller
  final TextEditingController houseBlockController = TextEditingController();
  final TextEditingController cityProvinceController = TextEditingController();
  final TextEditingController barangayController = TextEditingController();

  //Emergency Contact Information Controller
  final TextEditingController nameEmergencyController = TextEditingController();
  final TextEditingController lastEmergencyController = TextEditingController();
  final TextEditingController middleEmergencyController =
      TextEditingController();
  final TextEditingController relationshipEmergencyController =
      TextEditingController();
  final TextEditingController phoneNumberEmergencyController =
      TextEditingController();

  //Emergency Address Controller
  final TextEditingController houseBlockEmergencyController =
      TextEditingController();
  final TextEditingController cityProvinceEmergencyController =
      TextEditingController();
  final TextEditingController barangayEmergencyController =
      TextEditingController();

  //Account Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  //Announcement Controller
  final TextEditingController titleAnnouncementController =
      TextEditingController();
  final TextEditingController contentAnnouncementController =
      TextEditingController();

  //Emergency Hotline Controller
  final TextEditingController emergencyHotlineTitleController =
      TextEditingController();
  final TextEditingController emergencyHotlinePhoneNumberTextController =
      TextEditingController();

  // Focus Nodes
  //Employee Number Focus Node
  final FocusNode employeeNumberFocusNode = FocusNode();
  //Personal Information Focus Node
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode middleInitialFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();
  final FocusNode monthFocusNode = FocusNode();
  final FocusNode dayFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode();
  final FocusNode sexFocusNode = FocusNode();
  final FocusNode civilStatusFocusNode = FocusNode();
  final FocusNode bloodTypeFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  //Personal Address FocusNodes
  final FocusNode houseBlockFocusNode = FocusNode();
  final FocusNode cityProvinceFocusNode = FocusNode();
  final FocusNode barangayFocusNode = FocusNode();

  //Emergency Contact Information FocusNodes
  final FocusNode nameEmergencyFocusNode = FocusNode();
  final FocusNode lastEmergencyFocusNode = FocusNode();
  final FocusNode middleEmergencyFocusNode = FocusNode();
  final FocusNode relationshipEmergencyFocusNode = FocusNode();
  final FocusNode phoneNumberEmergencyFocusNode = FocusNode();

  //Emergency Contact FocusNodes
  final FocusNode houseBlockEmergencyFocusNode = FocusNode();
  final FocusNode cityProvinceEmergencyFocusNode = FocusNode();
  final FocusNode barangayEmergencyFocusNode = FocusNode();

  //Account FocusNodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode newEmailFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  //Announcement FocusNode
  final FocusNode titleAnnouncementFocusNode = FocusNode();
  final FocusNode contentAnnouncementFocusNode = FocusNode();

  //Emergency Hotline FocusNode
  final FocusNode emergencyHotlineTitleFocusNode = FocusNode();
  final FocusNode emergencyHotlinePhoneNumberFocusNode = FocusNode();

  String selectedSex = "";
  String selectedCivilStatus = "";
  String selectedMonth = "";
  String selectedBloodType = "";
  String selectedCityProvince = "";
  String selectedBarangay = "";
  String selectedRelationship = "";

  int getDaysinMonth() {
    switch (selectedMonth) {
      case "January":
      case "March":
      case "May":
      case "July":
      case "August":
      case "October":
      case "December":
        return 31;
      case "April":
      case "June":
      case "September":
      case "November":
        return 30;
      case "February":
        return 29;
      default:
        return 0;
    }
  }

  List<String> availableBarangays = [];

  // Constructor to listen to focus changes
  AuthorityVariable() {
    List<FocusNode> focusNodes = [
      //Employee Focus
      employeeNumberFocusNode,
      //Personal Information Focus
      firstNameFocusNode,
      lastNameFocusNode,
      middleInitialFocusNode,
      monthFocusNode,
      dayFocusNode,
      yearFocusNode,
      sexFocusNode,
      civilStatusFocusNode,
      bloodTypeFocusNode,
      phoneNumberFocusNode,
      //Address Focus
      houseBlockFocusNode,
      cityProvinceFocusNode,
      barangayFocusNode,
      //Emergency Contact Focus
      nameEmergencyFocusNode,
      lastEmergencyFocusNode,
      middleEmergencyFocusNode,
      relationshipEmergencyFocusNode,
      phoneNumberEmergencyFocusNode,
      //Emergency Address Focus
      houseBlockEmergencyFocusNode,
      cityProvinceEmergencyFocusNode,
      barangayEmergencyFocusNode,
      //Account Focus
      emailFocusNode,
      passwordFocusNode,
      newEmailFocusNode,
      newPasswordFocusNode,
      confirmPasswordFocusNode,
      phoneNumberFocusNode,
      //Announcement Focus
      titleAnnouncementFocusNode,
      contentAnnouncementFocusNode,
      //Emergency Hotline Focus
      emergencyHotlineTitleFocusNode,
      emergencyHotlinePhoneNumberFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() {
        notifyListeners();
      });
    }
  }

  //SELECTION
  void setSelectedAge(int age) {
    selectedAge = age;
    notifyListeners();
  }

  void setSelectedMonth(String month) {
    selectedMonth = month;
    dayController.clear(); // Reset the day when month changes
    notifyListeners();
  }

  void setSelectedSex(String sex) {
    selectedSex = sex;
    notifyListeners();
  }

  void setSelectedCivilStatus(String civilStatus) {
    selectedCivilStatus = civilStatus;
    notifyListeners();
  }

  void setSelectedBloodType(String bloodType) {
    selectedBloodType = bloodType;
    notifyListeners();
  }

  void setSelectedCityProvince(String cityProvince) {
    selectedCityProvince = cityProvince;
    availableBarangays = cityToBarangayMap[cityProvince] ?? [];
    selectedBarangay = "";
    notifyListeners();
  }

  void setSelectedBarangay(String barangay) {
    selectedBarangay = barangay;
    notifyListeners();
  }

  void setSelectedRelationship(String relationship) {
    selectedRelationship = relationship;
    notifyListeners();
  }

  //Image Upload Set
  void setProfileImage(XFile image) {
    profileImage = File(image.path);
    profileImagePath = image.path;
    notifyListeners();
  }

  void setidFrontImagePath(XFile? idFront) {
    String newPath = idFront?.path ?? '';

    if (idFrontImagePath == newPath) return;

    if (idFront == null) {
      idFrontImage = null;
      idFrontImagePath = '';
    } else {
      idFrontImage = File(idFront.path);
      idFrontImagePath = idFront.path;
    }

    notifyListeners();
  }

  void setidBackImagePath(XFile? idBack) {
    String newPath = idBack?.path ?? '';

    if (idBackImagePath == newPath) return;

    if (idBack == null) {
      idBackImage = null;
      idBackImagePath = '';
    } else {
      idBackImage = File(idBack.path);
      idBackImagePath = idBack.path;
    }
    notifyListeners();
  }

  void setTitle(String titleAnnouncement) {
    title = titleAnnouncement;
    notifyListeners();
  }

  void setContent(String contentAnnouncement) {
    content = contentAnnouncement;
    notifyListeners();
  }

  void setMedicalSwitch(bool value) {
    medicalSwitch = value;
    notifyListeners();
  }

  void setAmbulanceSwitch(bool value) {
    ambulanceSwitch = value;
    notifyListeners();
  }

  void setFireStationSwitch(bool value) {
    fireStationSwitch = value;
    notifyListeners();
  }

  void setPoliceSwitch(bool value) {
    policeSwitch = value;
    notifyListeners();
  }

  void setBarangaySwitch(bool value) {
    barangayPersonnelSwitch = value;
  }

  void updateNotificationCount(int count) {
    notificationCount = count;
    notifyListeners();
  }

  void clearData() {
    //Employee CLEAR
    employeeNumberController.clear();
    //Personal Information CLEAR
    firstNameController.clear();
    lastNameController.clear();
    middleInitController.clear();
    ageController.clear();
    monthController.clear();
    dayController.clear();
    yearController.clear();
    sexController.clear();
    civilStatusController.clear();
    bloodTypeController.clear();
    phoneNumberController.clear();
    //Address CLEAR
    houseBlockController.clear();
    cityProvinceController.clear();
    barangayController.clear();
    //Emergency Information CLEAR
    nameEmergencyController.clear();
    lastEmergencyController.clear();
    middleEmergencyController.clear();
    relationshipEmergencyController.clear();
    phoneNumberEmergencyController.clear();
    //Emergency Address CLEAR
    houseBlockEmergencyController.clear();
    cityProvinceEmergencyController.clear();
    barangayEmergencyController.clear();
    //Account Clear
    emailController.clear();
    passwordController.clear();
    newEmailController.clear();
    newPasswordController.clear();
    confirmPassController.clear();
    //Announcement Clear
    titleAnnouncementController.clear();
    contentAnnouncementController.clear();
    //Emergency Hotline Clear
    emergencyHotlineTitleController.clear();
    emergencyHotlinePhoneNumberTextController.clear();

    //Announcement Clear
    announcementChoice.clear();

    //For DATABASE
    email = "";

    //Reset Selection
    selectedAge = null;
    selectedDay = 1;
    selectedSex = "";
    selectedMonth = "";
    selectedCivilStatus = "";
    selectedBloodType = "";
    selectedCityProvince = "";
    selectedBarangay = "";
    selectedRelationship = "";

    //Reset Switch
    medicalSwitch = false;
    ambulanceSwitch = false;
    fireStationSwitch = false;
    policeSwitch = false;
    barangayPersonnelSwitch = false;

    //ProfileImage Reset
    profileImagePath = "";
    profileImage = null;
    //FrontIDImage Reset
    idFrontImagePath = "";
    idFrontImage = null;
    //BackIDImage Reset
    idBackImagePath = "";
    idBackImage = null;

    //Notification Reset
    notificationCount = 0;
    notifyListeners();
  }

  // Dispose all controllers and focus nodes
  @override
  void dispose() {
    //CONTROLLER DISPOSE
    //Employee Number DISPOSE
    employeeNumberController.dispose();
    //Personal Information Controller DISPOSE
    firstNameController.dispose();
    lastNameController.dispose();
    middleInitController.dispose();
    ageController.dispose();
    monthController.dispose();
    dayController.dispose();
    yearController.dispose();
    sexController.dispose();
    civilStatusController.dispose();
    bloodTypeController.dispose();
    phoneNumberController.dispose();
    //Address Controller DISPOSE
    houseBlockController.dispose();
    cityProvinceController.dispose();
    barangayController.dispose();
    //Emergency Controller DISPOSe
    nameEmergencyController.dispose();
    lastEmergencyController.dispose();
    middleEmergencyController.dispose();
    relationshipEmergencyController.dispose();
    phoneNumberEmergencyController.dispose();
    //Emergency Address DISPOSE
    houseBlockEmergencyController.dispose();
    cityProvinceEmergencyController.dispose();
    barangayEmergencyController.dispose();
    //Account Controller DISPOSE
    emailController.dispose();
    passwordController.dispose();
    newEmailController.dispose();
    newPasswordController.dispose();
    confirmPassController.dispose();
    //Announcement Controller DISPOSE
    titleAnnouncementController.dispose();
    contentAnnouncementController.dispose();
    //Emergency Hotline Controller DISPOSE
    emergencyHotlineTitleController.dispose();
    emergencyHotlinePhoneNumberTextController.dispose();

    //FOCUSNODE DISPOSE
    //Employee Number FocusNode DISPOSE
    employeeNumberFocusNode.dispose();
    //Personal Information FocusNode DISPOSE
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    middleInitialFocusNode.dispose();
    ageFocusNode.dispose();
    monthFocusNode.dispose();
    dayFocusNode.dispose();
    yearFocusNode.dispose();
    civilStatusFocusNode.dispose();
    bloodTypeFocusNode.dispose();
    sexFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    //Address FocusNode DISPOSE
    houseBlockFocusNode.dispose();
    cityProvinceFocusNode.dispose();
    barangayFocusNode.dispose();
    //Emergency FocusNode DISPOSE
    nameEmergencyFocusNode.dispose();
    lastEmergencyFocusNode.dispose();
    middleEmergencyFocusNode.dispose();
    relationshipEmergencyFocusNode.dispose();
    phoneNumberEmergencyFocusNode.dispose();
    //Emergency Address FocusNode DISPOSE
    houseBlockEmergencyFocusNode.dispose();
    cityProvinceEmergencyFocusNode.dispose();
    barangayEmergencyFocusNode.dispose();
    //Account FocusNode DISPOSE
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    newEmailFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    //Announcement FocusNode DISPOSE
    titleAnnouncementFocusNode.dispose();
    contentAnnouncementFocusNode.dispose();
    //Emergency Hotline FocusNode DISPOSE
    emergencyHotlineTitleFocusNode.dispose();
    emergencyHotlinePhoneNumberFocusNode.dispose();

    clearData();
    super.dispose();
  }

  void toggleChoice(String choice) {
    final allOptions = ["Resident", "Authority"]; // Add more if needed

    if (choice == "All") {
      if (!announcementChoice.contains("All")) {
        announcementChoice = [...allOptions, "All"];
      } else {
        announcementChoice.clear();
      }
    } else {
      if (announcementChoice.contains(choice)) {
        announcementChoice.remove(choice);
      } else {
        announcementChoice.add(choice);
      }

      if (allOptions.every((opt) => announcementChoice.contains(opt))) {
        if (!announcementChoice.contains("All")) {
          announcementChoice.add("All");
        }
      } else {
        announcementChoice.remove("All");
      }
    }

    filterAnnouncements();
    notifyListeners();
  }

  void toggleSelectionOnly(String choice) {
    final allOptions = ["Resident", "Authority"];

    if (choice == "All") {
      final allSelected = allOptions.every(
        (opt) => announcementChoice.contains(opt),
      );

      if (!announcementChoice.contains("All")) {
        if (allSelected) {
          announcementChoice.add("All");
        } else {
          for (var option in allOptions) {
            if (!announcementChoice.contains(option)) {
              announcementChoice.add(option);
            }
          }
          announcementChoice.add("All");
        }
      } else {
        announcementChoice.clear();
      }
    } else {
      if (announcementChoice.contains(choice)) {
        announcementChoice.remove(choice);
      } else {
        announcementChoice.add(choice);
      }

      final allSelected = allOptions.every(
        (opt) => announcementChoice.contains(opt),
      );
      if (allSelected && !announcementChoice.contains("All")) {
        announcementChoice.add("All");
      } else if (!allSelected) {
        announcementChoice.remove("All");
      }
    }

    notifyListeners(); // only notifies UI; doesn't call filterAnnouncements
  }

  void filterAnnouncements() {
    if (announcementChoice.contains("All")) {
      // Show only announcements with both Resident & Authority
      filteredAnnouncements =
          announcement.where((item) {
            final aud = List<String>.from(item['audience'] ?? []);
            return aud.contains("Resident") && aud.contains("Authority");
          }).toList();
    } else if (announcementChoice.isEmpty) {
      // No filters selected = show all
      filteredAnnouncements = [...announcement];
    } else {
      // Match ANY selected audience (OR logic)
      filteredAnnouncements =
          announcement.where((item) {
            final aud = List<String>.from(item['audience'] ?? []);
            return announcementChoice.any((selected) => aud.contains(selected));
          }).toList();
    }

    notifyListeners(); // Make sure UI updates
  }

  void setAnnouncements(List<Map<String, dynamic>> list) {
    announcement = list;
    notifyListeners();
  }

  void clearChoice() {
    announcementChoice.clear();
    notifyListeners();
  }
}
