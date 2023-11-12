import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/doctor_patient_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/profile_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Message/message_user_Item_widget.dart';

class ChatsScreen extends StatefulWidget {
  final UserCollection userdata;
  const ChatsScreen({super.key, required this.userdata});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _currentIndex = 2;

  late Future<List<Map<String, dynamic>>> fetchPatients;

  @override
  void initState() {
    super.initState();

    fetchPatients = fetchPatientNames();
  }

  Future<List<Map<String, dynamic>>> fetchPatientNames() async {
    final controller = Get.put(DoctorPatientController());
    final patientDetails =
        await controller.listAllDoctorPatientDetails(widget.userdata.id);

    List<Map<String, dynamic>> patientDataList = [];
    print(patientDetails);
    for (final patientDetail in patientDetails) {
      final firstName = patientDetail['FirstName'];
      final lastName = patientDetail['LastName'];
      final mergedName = '$firstName $lastName';
      final patientEmail = patientDetail['Email'];

      patientDataList.add({
        'name': mergedName,
        'email': patientEmail,
      });
      print(patientDataList);
    }

    return patientDataList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            onPressed: () {
              Get.to(() => const Dashboard());
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
          ),
          centerTitle: true,
          title: Text(
            "Chats",
            style: tpharagraph4.copyWith(color: blackColor),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: gray1,
          selectedItemColor: white,
          unselectedItemColor: blackColor,
          selectedLabelStyle: tpharagraph7,
          unselectedLabelStyle: tpharagraph7,
          onTap: (value) {
            // Respond to item press.
            setState(() {
              _currentIndex = value;
              if (_currentIndex == 1) {
                Get.to(() => ProfileScreen(
                      userdata: widget.userdata,
                      bottomNegigatorIndex: _currentIndex,
                    ));
              } else if (_currentIndex == 0) {
                Get.to(() => const Dashboard());
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(FontAwesomeIcons.user),
            ),
            BottomNavigationBarItem(
              label: "Message",
              icon: Icon(Icons.chat_bubble_outline),
            ),
          ],
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchPatients, // Await the fetchPatients Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return const Center(
                  child:
                      CircularProgressIndicator()); // You can replace this with your loading widget
            } else if (snapshot.hasError) {
              // Handle any errors here
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Handle cases where there is no data to display
              print("No patient data available. Doctor Chats");
              return AlertDialog(
                title: const Text("Message"),
                content: const Text("You Dont Have any patients"),
                actions: [
                  TextButton(
                      onPressed: () => Get.back(), child: const Text("Back"))
                ],
              );
            } else {
              // Use the length of the fetched data
              final List<Map<String, dynamic>> patientDataList = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: patientDataList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => MessageUserItemWidget(
                  patient: patientDataList[index],
                  userdata: widget.userdata, // Pass the patient data
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
