import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notificaciones_firebase/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.getDeviceToken().then((value) {
      print("Device token");
      print(value);
    });
  }

  void _sendNotification() async {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;

      const movil =
          "duBVFsSRRYGL-hitcM9GYj:APA91bG687ofR7l8M5EvG4Ml757TsQfCuSEswZmftcXvhQubvwySzPFZmHf7oBXXo45syGi0F1agtzsz6bs0yvh_A9SqtS3aheKS5239I_ShBAs7OOfVpHKjKgwXdLLrc6akKUl-Dn-g";
      const wear =
          "c3uptGqTQnyT8jyQtvm1Uw:APA91bHyQsn_05eP6CJat1uFWtGFrXQXoUFisZQXYFGdHSIMICzqh1NU3IjCTaSQHIeAgVVMBM9eNQGWpFNdHCZecODzXJ2_-pPWkIX84aFjxN-dHbNK3b_1HPafANDZQx-AwL9THWkl";

      var data = {
        "to": movil,
        "priority": "high",
        "notification": {
          "title": title,
        },
        "data": {
          "type": "msj",
          "id": "458748",
        },
      };

      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization":
              "key=AAAAx_CoI7w:APA91bFg4kxmhMLjc334SBFcJwiEkOpR8MlsWejqDQG45ICQCrHoqVKvC3jRTeAKW-VR2JKPqE9c5jI696BjOKjenwug_kQugqWibLEBKc0brNjCZ2uH0voA60vN4QJIW0ZsO_6L_omZ",
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://howpple.com/wp-content/uploads/2020/04/C%C3%B3mo-usar-un-GIF-como-esfera-en-el-Apple-Watch-Howpple-tutoriales-Apple.gif"), // Reemplaza por la URL de la imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  // Si el ancho de pantalla es menor a 400 (smartwatch)
                  return _buildSmartwatchLayout();
                } else {
                  // Si el ancho de pantalla es mayor o igual a 400 (smartphone)
                  return _buildSmartphoneLayout();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmartwatchLayout() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _titleController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Título de la notificación",
              labelStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), 
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa un título';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _sendNotification,
            style: ElevatedButton.styleFrom(
              elevation: 8,
              primary: Colors.white.withOpacity(0.2),
              onPrimary: Colors.white, // Cambio del color del texto del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.white.withOpacity(0.2),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartphoneLayout() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _titleController,
            style: TextStyle(color: Colors.white), // Cambio del color del texto del input
            decoration: InputDecoration(
              labelText: "Título de la notificación",
              labelStyle: TextStyle(color: Colors.white), // Cambio del color del título
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Cambio del color del borde del input al enfocarse
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa un título';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendNotification,
            style: ElevatedButton.styleFrom(
              elevation: 8,
              primary: Colors.white.withOpacity(0.2),
              onPrimary: Colors.white, // Cambio del color del texto del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.white.withOpacity(0.2),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
