import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/manage_user_controller.dart';
import 'package:my_app/DatabaseCollection/user_collection.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/Card/user_List_card.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ActiveUserScreenState();
}

class _ActiveUserScreenState extends State<ManageUserScreen> {
  final List<String> category = ["Patient", "Doctor", "Active", "Deactive"];
  List<String> selectedCategory = [];

  String searchQuery = '';

  final manageUserController = Get.put(ManageUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Manage User",
          style: tpharagraph4.copyWith(color: blackColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: const Offset(0, 2), // Shadow offset
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search_outlined),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: category
                  .map(
                    (category) => FilterChip(
                        elevation: 8,
                        label: Text(
                          category,
                          style: tpharagraph6,
                        ),
                        selected: selectedCategory.contains(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategory.add(category);
                            } else {
                              selectedCategory.remove(category);
                            }
                          });
                        }),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<UserCollection>>(
                  future: manageUserController.allUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final userListCards = snapshot.data!
                            .where((user) =>
                                (selectedCategory.isEmpty ||
                                    (selectedCategory.contains("Patient") &&
                                        user.userType == "Patient") ||
                                    (selectedCategory.contains("Doctor") &&
                                        user.userType == "Doctor") ||
                                    (selectedCategory.contains("Active") &&
                                        user.status == "Active") ||
                                    (selectedCategory.contains("Deactive") &&
                                        user.status == "Deactive")) &&
                                (user.firstName
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()) ||
                                    user.lastName
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()) ||
                                    user.email
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase())))
                            .map((user) {
                          String userName =
                              "${user.firstName} ${user.lastName}";
                          return UserListCard(
                            userName: userName,
                            user: user,
                          );
                        }).toList();

                        return Column(
                          children: userListCards,
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return const Center(
                            child: Text("Something Went wrong"));
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
