import 'package:barber_app/view/pages/admPages/edit_services_page.dart';
import 'package:barber_app/view/pages/admPages/set_open_hours_page.dart';
import 'package:barber_app/view/pages/booking_page.dart';
import 'package:barber_app/view/widgets/danger_alertbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configurar'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 5,
          children: [
            Icon(Icons.settings, color: Colors.amber, size: 40),
            Divider(),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text(
                    "Definir Serviços",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServicesPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.more_time),
                  title: Text(
                    "Definir Horários",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetOpenHoursPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text(
                    "Definir Férias",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white54,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Criar Agendamento",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people_outline),
                  enabled: false,
                  title: Text(
                    "Gerenciar Profissionais",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white54,
                  ),
                  onTap: () {},
                ),
                SizedBox(height: 100),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.delete_sweep,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Limpar Todos Agendamentos",
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => DangerAlertbox(
                            function: 0,
                            serviceId: 0,
                          ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text(
                    "Desativação Total",
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => DangerAlertbox(
                            function: 1,
                            serviceId: 0,
                          ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
