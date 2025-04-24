import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> mensajes = [];

  @override
  void initState() {
    super.initState();
    _cargarMensajes();
  }

  Future<void> _cargarMensajes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mensajes = prefs.getStringList('notificaciones') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notificaciones')),
      body:
          mensajes.isEmpty
              ? Center(child: Text('No hay notificaciones aún'))
              : ListView.builder(
                itemCount: mensajes.length,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(mensajes[index]),
                    ),
              ),
    );
  }
}
