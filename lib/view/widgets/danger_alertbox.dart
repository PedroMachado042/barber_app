import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DangerAlertbox extends StatefulWidget {
  const DangerAlertbox({
    super.key,
    required this.function,
    required this.serviceId,
  });
  final int function;
  final int serviceId;

  @override
  State<DangerAlertbox> createState() => _DangerAlertboxState();
}

class _DangerAlertboxState extends State<DangerAlertbox> {
  bool agreed = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 220,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getWarningMessage(widget.function),
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.white,
                  value: agreed,
                  onChanged: (value) {
                    setState(() {
                      agreed = value ?? false;
                    });
                  },
                ),
                Text(
                  'Contiunuar a operação',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                  255,
                  110,
                  25,
                  19,
                ),
                fixedSize: Size(240, 20),
              ),
              onPressed:
                  agreed
                      ? () async {
                        switch (widget.function) {
                          case 0:
                            {
                              await FirestoreService().deleteAllData();
                              Fluttertoast.showToast(
                                msg: 'Todos agendamentos foram deletados!',
                                backgroundColor: Colors.black87,
                              );
                              print('sus');
                            }
                          case 1:
                            {
                              FirestoreService().SelfDestruct();
                              Phoenix.rebirth(context);
                            }
                          case 2:
                            {
                              await FirestoreService().deleteService(
                                widget.serviceId,
                              );
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                msg: 'Serviço deletado com sucesso!',
                                backgroundColor: Colors.black87,
                              );
                              print(
                                'que isso meu fio calma${widget.serviceId}',
                              );
                            }
                        }
                        Navigator.pop(context);
                      }
                      : null,
              child: Text(
                'Continuar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getWarningMessage(int function) {
  switch (function) {
    case 0:
      return 'Essa opção irá deletar todo o conteúdo do banco de dados, nem mesmo um desenvolvedor pode reverter a operação.';
    case 1:
      return 'Essa opção irá desativar o aplicativo para todos os usuários e só poderá ser revertida por um desenvolvedor.';
    case 2:
      return 'Essa opção irá deletar o serviço para todos os usuários permanentemente.';
    default:
      return 'Ação desconhecida.'; //nunca é pra aparecer
  }
}
