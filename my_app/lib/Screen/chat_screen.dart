import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/profile_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Message/chat_messages.dart';
import 'package:my_app/Widget/Message/chat_text_field.dart';

class ChatScreen extends StatefulWidget {
  final UserCollection userdata;
  final Map<String, dynamic> patient;
  const ChatScreen({super.key, required this.userdata, required this.patient});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _currentIndex = 2;
  // Add a GlobalKey for the RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  // Add a variable to track whether the data is being refreshed
  bool isRefreshing = false;
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
            widget.patient['name'] ?? '',
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
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: () async {
            // Implement your refresh  again
            setState(() {
              // Set the isRefreshing flag to true
              isRefreshing = true;
            });
            // Simulate a delay for the refresh
            await Future.delayed(const Duration(seconds: 2));

            setState(() {
              // Set the isRefreshing flag to false after refreshing
              isRefreshing = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ChatMessages(
                  receiverEmail: widget.patient['email'],
                  currentUserId: widget.userdata.id!,
                ),
                ChatTextField(
                  receiverEmail: widget.patient['email'],
                  senderId: widget.userdata.id!,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
