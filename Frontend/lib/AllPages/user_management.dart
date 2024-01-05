import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<User> suggestions = [];
  List<User> listUser = [];

  @override
  void initState() {
    super.initState();
    suggestions = List.from(listUser);
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
                                child: Row(
                                    children: [
                                      // CircleAvatar(
                                      //   backgroundImage:
                                      //       NetworkImage(suggestions[index].avatar),
                                      // ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: ClipOval(
                                          child: Image.network(
                                            suggestions[index].avatar,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context,
                                                Widget child,
                                                ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Text('Error loading image');
                                            },
                                          ),
                                        ),
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
                                        ]
                                      )
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
                                title: Text("Confirmation"),
                                content:
                                    Text("Are you sure to change the status?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Đóng hộp thoại và xử lý xác nhận
                                      Navigator.of(context).pop();
                                      _handleConfirmation(suggestions[index]);
                                    },
                                    child: Text("Confirm"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Đóng hộp thoại
                                      Navigator.of(context).pop();
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

  void _handleConfirmation(User user) {
    setState(() {
      // Thay đổi trạng thái
      user.status = (user.status == 'active') ? 'unactive' : 'active';
    });
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
