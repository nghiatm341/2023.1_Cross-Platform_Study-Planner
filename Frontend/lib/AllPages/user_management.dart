import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<User> suggestions = [];
  List<User> listUser = [
    User(
        firstName: 'Dung',
        lastName: 'Nong',
        status: 'block',
        id: 1,
        avatar:
            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'Dung',
        lastName: 'Viet',
        status: 'active',
        id: 2,
        avatar:
            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'Nam',
        lastName: 'Pham',
        status: 'active',
        id: 3,
        avatar:
            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'Nghia',
        lastName: 'Nong',
        status: 'active',
        id: 4,
        avatar:
            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'Son',
        lastName: 'Nguyen',
        status: 'active',
        id: 5,
        avatar:
            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'Hoang',
        lastName: 'Vu',
        status: 'active',
        id: 6,
        avatar:
            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'First',
        lastName: 'Last1',
        status: 'active',
        id: 7,
        avatar:
        'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'First',
        lastName: 'Last2',
        status: 'active',
        id: 8,
        avatar:
        'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'First',
        lastName: 'Last3',
        status: 'active',
        id: 9,
        avatar:
        'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'First',
        lastName: 'Last4',
        status: 'active',
        id: 10,
        avatar:
        'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'First',
        lastName: 'Last5',
        status: 'active',
        id: 11,
        avatar:
        'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
    User(
        firstName: 'First',
        lastName: 'Last6',
        status: 'active',
        id: 12,
        avatar:
        'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
  ];

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
