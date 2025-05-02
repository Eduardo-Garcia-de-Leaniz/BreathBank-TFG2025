import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> mensajes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _verificarYcargarMensajes();
  }

  Future<void> _verificarYcargarMensajes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _cargarMensajes();
    }
    setState(() {
      cargando = false;
    });
  }

  Future<void> _cargarMensajes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mensajes = prefs.getStringList('notificaciones') ?? [];
    });
  }

  Future<bool> _borrarMensajes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notificaciones');

    setState(() {
      mensajes.clear();
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Si el usuario está logueado, regresa al Dashboard
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          Navigator.pop(
            context,
          ); // Si no está logueado, regresa a la pantalla anterior
        }
        return false; // Evita el comportamiento predeterminado de "pop"
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notificaciones'),
          actions:
              mensajes.isNotEmpty && user != null
                  ? [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _borrarMensajes().then((_) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mensajes borrados')),
                          );
                        });
                      },
                      tooltip: 'Borrar mensajes',
                    ),
                  ]
                  : null,
        ),
        body:
            cargando
                ? const Center(child: CircularProgressIndicator())
                : user == null
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Debes iniciar sesión para ver tus notificaciones.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Ir al login'),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/login',
                            arguments: {
                              'desdeNotificacion': true,
                            }, // O false, según el caso
                          );
                        },
                      ),
                    ],
                  ),
                )
                : mensajes.isEmpty
                ? const Center(child: Text('No hay notificaciones aún'))
                : ListView.builder(
                  itemCount: mensajes.length,
                  itemBuilder:
                      (context, index) => ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(mensajes[index]),
                      ),
                ),
      ),
    );
  }
}
