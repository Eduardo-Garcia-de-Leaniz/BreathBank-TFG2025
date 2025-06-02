import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; // Necesario para la navegación

const String kNoData = 'no-data'; // Constante para valores faltantes

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String argumento = message.data['CLAVE1'] ?? kNoData;
  message.data['ruta'] ?? '/'; // Ruta por defecto si no se proporciona

  await _guardarMensaje(argumento);
}

Future<void> _guardarMensaje(String mensaje) async {
  final prefs = await SharedPreferences.getInstance();
  final mensajes = prefs.getStringList('notificaciones') ?? [];
  mensajes.add(mensaje);
  await prefs.setStringList('notificaciones', mensajes);
}

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  Future<void> initNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String argumento = message.data['CLAVE1'] ?? kNoData;
      String ruta = message.data['ruta'] ?? '/';

      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);

      if (context.mounted) {
        _navegarA(context, ruta);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String argumento = message.data['CLAVE1'] ?? kNoData;
      String ruta = message.data['ruta'] ?? '/';

      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);

      if (context.mounted) {
        _navegarA(context, ruta);
      }
    });

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      String argumento = initialMessage.data['CLAVE1'] ?? kNoData;
      String ruta = initialMessage.data['ruta'] ?? '/';

      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);

      if (context.mounted) {
        _navegarA(context, ruta);
      }
    }
  }

  void _navegarA(BuildContext context, String ruta) {
    Navigator.pushNamed(context, ruta);
  }

  void dispose() {
    _mensajesStreamController.close();
  }
}
