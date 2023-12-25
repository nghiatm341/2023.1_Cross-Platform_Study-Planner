import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ultils/store.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  List<User> suggestions = [];
  late List<User> listUser = [];
  TextEditingController scoreController = TextEditingController();

  Future<void> fetchListUser() async {
    debugPrint("Fetch api get list user");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + AppStore.TOKEN.toString()
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/user/get-list'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List userItem = jsonData['data'];
        setState(() {
          listUser = userItem.map((e) {
            return User(
                firstName: e['firstName'],
                lastName: e['lastName'],
                status: e['status'],
                id: e['id'],
                avatar: e['avatar'],
                );
          }).toList();
        });

        suggestions = List.from(listUser);
        debugPrint('Response message: ${jsonData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> blockUser(User user) async {
    debugPrint("Call api block user");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + AppStore.TOKEN.toString()
    };

    Map<String, dynamic> postData = {'userId': user.id};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/admin/block'),
        headers: headers,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        fetchListUser();
        debugPrint('Block user successfully!');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> unblockUser(User user) async {
    debugPrint("Call api unblock user");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + AppStore.TOKEN.toString()
    };

    Map<String, dynamic> postData = {
      'unblockedUserId': user.id,
      'score': scoreController.text
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/admin/unblock'),
        headers: headers,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        fetchListUser();
        debugPrint('Unblock user successfully!');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchListUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User Management"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5)),
              SearchBar(
                hintText: 'Search for account',
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {},
                onChanged: (String query) {
                  if (query.isNotEmpty) {
                    setState(() {
                      suggestions = listUser
                          .where((item) =>
                              ('${item.firstName} ${item.lastName}')
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                          .toList();
                    });
                  } else {
                    setState(() {
                      suggestions = List.from(listUser);
                    });
                  }
                },
                leading: const Icon(Icons.search),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  padding: EdgeInsets.all(6.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Row(children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(suggestions[index].avatar),
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${suggestions[index].firstName} ${suggestions[index].lastName}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'ID: ${suggestions[index].id}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ])
                            ])),
                            Text(
                              suggestions[index].status == 'active'
                                  ? 'ACTIVE'
                                  : 'BLOCK',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: suggestions[index].status == 'active'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle item selection
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmation"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Are you sure to change the status?"),
                                    SizedBox(height: 10.0),
                                    suggestions[index].status != 'active'
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Set score: "),
                                              Expanded(
                                                child: TextField(
                                                  controller: scoreController,
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                                                  ],
                                                )
                                              )
                                            ],
                                          )
                                        : Text("Score will be set to 0"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Đóng hộp thoại và xử lý xác nhận
                                      Navigator.of(context).pop();
                                      suggestions[index].status == 'active'
                                          ? blockUser(suggestions[index])
                                          : unblockUser(suggestions[index]);
                                      scoreController.text = '';
                                    },
                                    child: Text("Confirm"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Đóng hộp thoại
                                      Navigator.of(context).pop();
                                      scoreController.text = '';
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  String status;
  final int id;
  final String avatar;

  User(
      {required this.firstName,
      required this.lastName,
      required this.status,
      required this.id,
      required this.avatar});
}
