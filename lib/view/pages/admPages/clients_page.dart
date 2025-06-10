import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widgets/client_tile_widget.dart';
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
                      ? Center(child: CircularProgressIndicator(color: Colors.white,))
                      : GridView.builder(
                        itemCount: usersCount,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 140,
                            ),
                        itemBuilder: (context, index) {
                          final user = allUsers[index];
                          return ClientTileWidget(userData: user,);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
