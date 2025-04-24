import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

// 🔔 Función global para manejar mensajes en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔔 [Background] Título: ${message.notification?.title}");
  print("🔔 [Background] Datos: ${message.data}");

  String argumento = message.data['CLAVE1'] ?? 'no-data';
  await _guardarMensaje(argumento);
}

// 💾 Función para guardar mensaje localmente
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

  Future<void> initNotifications() async {
    // Solicitar permisos en iOS
    await _firebaseMessaging.requestPermission();

    // Obtener el token
    final token = await _firebaseMessaging.getToken();
    print("🔑 Token: $token");

    // 📱 Primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("📱 [Foreground] Título: ${message.notification?.title}");
      print("📱 [Foreground] Datos: ${message.data}");

      String argumento = message.data['CLAVE1'] ?? 'no-data';
      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);
    });

    // 📦 Segundo plano (registrar handler global)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 📬 Cuando la app se abre desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
        "📬 [Abierta desde notificación] Título: ${message.notification?.title}",
      );
      print("📬 Datos: ${message.data}");

      String argumento = message.data['CLAVE1'] ?? 'no-data';
      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);
    });

    // 🚀 App lanzada desde una notificación (cold start)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 [Inicial] Título: ${initialMessage.notification?.title}');
      print('🚀 Datos: ${initialMessage.data}');

      String argumento = initialMessage.data['CLAVE1'] ?? 'no-data';
      await _guardarMensaje(argumento);
      _mensajesStreamController.sink.add(argumento);
    }
  }

  void dispose() {
    _mensajesStreamController.close();
  }
}
