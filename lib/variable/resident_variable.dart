import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ResidentVariable extends ChangeNotifier {
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
  String firstName = "Jermaine Miguel";
  String get getFirstName => firstName;
  String lastName = "Gonzales";
  String get getLastName => lastName;
  String middleInitial = "";
  String get getMiddleInitial => middleInitial;
  int age = 0;
  int get getAge => age;
  String month = "August";
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
  String phoneNumber = "9123456677";
  String get getPhoneNumber => phoneNumber;

  //Personal Address DATABASE
  String houseBlock = "Block St.";
  String get getHouseBlock => houseBlock;
  String cityProvince = "Malolos, Bulacan";
  String get getCityProvince => cityProvince;
  String barangay = "Lugam";
  String get getBarangay => barangay;

  //Emergency Contact DATABASE
  String nameEmergency = "N/A";
  String get getNameEmergency => nameEmergency;
  String lastEmergency = "N/A";
  String get getLastEmergency => lastEmergency;
  String middleEmergency = "N/A";
  String get getMiddleEmergency => middleEmergency;
  String relationshipEmergency = "N/A";
  String get getRelationshipEmergency => relationshipEmergency;
  String phoneNumberEmergency = "";
  String get getPhoneNumberEmergency => phoneNumberEmergency;

  //Emergency Address DATABASE
  String houseBlockEmergency = "";
  String get getHouseBlockEmergency => houseBlockEmergency;
  String cityProvinceEmergency = "";
  String get getCityProvinceEmergency => cityProvinceEmergency;
  String barangayEmergency = "";
  String get getBarangayEmergency => barangayEmergency;

  //Account DATABASE
  String email = "sample@gmail.com";
  String get getEmail => email;

  //PROFILE IMAGE
  File? profileImage;
  String profileImagePath = "";
  File? get getProfileImage => profileImage;

  //FRONT IMAGE
  File? idFrontImage;
  String idFrontImagePath = "";
  File? get getidFrontImage => idFrontImage;

  //BACK IMAGE
  File? idBackImage;
  String idBackImagePath = "";
  File? get getidBackImage => idBackImage;

  int? selectedAge;

  int selectedDay = 1;

  int notificationCount = 0;

  // Text Controllers
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

  //Accounts Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  // Focus Nodes
  //Personal Information FocusNodes
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

  //Accounts FocusNodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode newEmailFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

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
  ResidentVariable() {
    List<FocusNode> focusNodes = [
      //Personal Information Focus
      firstNameFocusNode,
      lastNameFocusNode,
      middleInitialFocusNode,
      ageFocusNode,
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
    ];

    for (var node in focusNodes) {
      node.addListener(() {
        notifyListeners();
      });
    }
  }

  // SELECTION
  void setSelectedAge(int age) {
    selectedAge = age;
    notifyListeners();
  }

  void setSelectedMonth(String month) {
    selectedMonth = month;
    selectedDay = 1;
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

  void updateNotificationCount(int count) {
    notificationCount = count;
    notifyListeners();
  }

  void clearData() {
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
    //Emergemcy Address CLEAR
    houseBlockEmergencyController.clear();
    cityProvinceEmergencyController.clear();
    barangayEmergencyController.clear();
    //Account CLEAR
    emailController.clear();
    passwordController.clear();
    newEmailController.clear();
    newPasswordController.clear();
    confirmPassController.clear();

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

    //ProfileImage Reset
    profileImagePath = "";
    profileImage = null;
    //FrontIDImage Reset
    idFrontImagePath = "";
    idFrontImage = null;
    //BackIDImage Reset
    idBackImagePath = "";
    idBackImage = null;

    //NotificationReset
    notificationCount = 0;
    notifyListeners();
  }

  // Dispose all controllers and focus nodes
  @override
  void dispose() {
    //CONTROLLER DISPOSE
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
    //Emergency Controller DISPOSE
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
    //FOCUSNODE DISPOSE
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
    middleEmergencyController.dispose();
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
    clearData();
    super.dispose();
  }
}
