import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Necesario para la navegación

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String argumento = message.data['CLAVE1'] ?? 'no-data';
  String ruta =
      message.data['ruta'] ?? '/'; // Ruta por defecto si no se proporciona

  await _guardarMensaje(argumento);
  // Aquí podrías llamar a un método de navegación global si tu app ya está en ejecución
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

    final token = await _firebaseMessaging.getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String argumento = message.data['CLAVE1'] ?? 'no-data';
      String ruta =
          message.data['ruta'] ?? '/'; // Ruta por defecto si no se proporciona

      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);

      // Navegar a la ruta indicada
      _navegarA(context, ruta);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String argumento = message.data['CLAVE1'] ?? 'no-data';
      String ruta =
          message.data['ruta'] ?? '/'; // Ruta por defecto si no se proporciona

      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);

      // Navegar a la ruta indicada
      _navegarA(context, ruta);
    });

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      String argumento = initialMessage.data['CLAVE1'] ?? 'no-data';
      String ruta =
          initialMessage.data['ruta'] ??
          '/'; // Ruta por defecto si no se proporciona

      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);

      // Navegar a la ruta indicada
      _navegarA(context, ruta);
    }
  }

  void _navegarA(BuildContext context, String ruta) {
    // Realizar la navegación a la ruta indicada
    // Aquí puedes usar Navigator.pushNamed o Navigator.push, dependiendo de tu arquitectura
    Navigator.pushNamed(context, ruta);
  }

  void dispose() {
    _mensajesStreamController.close();
  }
}
