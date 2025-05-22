import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  int? usersCount = 0;
  List<Map<String, String>> allUsers = [];

  @override
  void initState() {
    super.initState();
    countUsers();
  }

  void countUsers() async {
    usersCount = await FirestoreService().countUsers();
    allUsers = await FirestoreService().getAllUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clientes'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(Icons.people_alt, color: Colors.amber, size: 40),
            Divider(),
            Container(
              height: 550,
              child:
                  usersCount == 0
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        itemCount: usersCount,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 140,
                            ),
                        itemBuilder: (context, index) {
                          final user = allUsers[index];
                          List<String> names = user['username']!
                              .split(' ');
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                onTap: () {
                                  print(user['email']);
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.black38,
                                    ),
                                    SizedBox(height: 5),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.black45,
                                      foregroundImage: AssetImage(
                                        'assets/images/guestPic.png',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                      height: 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            names[0],
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          if (names.length > 1)
                                            Text(
                                              names[1],
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
