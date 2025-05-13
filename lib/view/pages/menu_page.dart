import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/pages/drawer/drawer_page.dart';
import 'package:barber_app/view/widgets/menu_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Menu'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      drawer: Drawer(child: DrawerPage()),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 340,
                child: Opacity(
                  opacity: 0.35,
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 230, width: double.infinity),
                    Image.asset(
                      'assets/images/logotop.png',
                      height: 160,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: isADM,
            builder: (Bcontext, isLogged, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child:
                    isADM.value
                        ? Column(
                          children: [
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                MenuButton(
                                  text: 'Horários',
                                  icon: Icons.calendar_month,
                                  id: 0,
                                ),
                                MenuButton(
                                  text: 'Clientes',
                                  icon: Icons.people_alt,
                                  id: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                MenuButton(
                                  text: 'Gráficos',
                                  icon: Icons.auto_graph,
                                  id: 2,
                                ),
                                MenuButton(
                                  text: 'Configurar',
                                  icon: Icons.settings,
                                  id: 3,
                                ),
                              ],
                            ),
                          ],
                        )
                        : Column(
                          children: [
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                MenuButton(
                                  text: 'Agendar',
                                  icon: Icons.edit,
                                  id: 0,
                                ),
                                MenuButton(
                                  text: 'Horários',
                                  icon: Icons.calendar_month,
                                  id: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                MenuButton(
                                  text: 'Serviços',
                                  icon: Icons.content_cut_sharp,
                                  id: 2,
                                ),
                                MenuButton(
                                  text: 'Sobre Nós',
                                  icon: Icons.location_on_sharp,
                                  id: 3,
                                ),
                              ],
                            ),
                          ],
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}
