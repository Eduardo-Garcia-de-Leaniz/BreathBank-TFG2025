import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test1Screen extends StatefulWidget {
  @override
  _Test1ScreenState createState() => _Test1ScreenState();
}

class _Test1ScreenState extends State<Test1Screen> {
  String descripcion = "Cargando...";
  String instrucciones = "Cargando...";

  @override
  void initState() {
    super.initState();
    _cargarTextos();
  }

  Future<void> _cargarTextos() async {
    String desc = await rootBundle.loadString(
      'assets/texts/description_test1.txt',
    );
    String instr = await rootBundle.loadString(
      'assets/texts/instructions_test1.txt',
    );

    setState(() {
      descripcion = desc;
      instrucciones = instr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Test1(),
      ),
      resizeToAvoidBottomInset: true,
      body: PageView(
        children: [
          // Primera página: Descripción del test
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: const Color.fromARGB(255, 188, 252, 245),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registro de respiraciones en reposo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(descripcion, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    Text(
                      'Instrucciones:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(instrucciones, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: MediaQuery.of(context).size.height * 3 / 8,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: const Color.fromARGB(255, 7, 71, 94),
                ),
              ),
            ],
          ),
          // Segunda página: La prueba en sí
          Container(
            color: const Color.fromARGB(255, 188, 252, 245),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aquí va el dibujo de la prueba',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  top: MediaQuery.of(context).size.height * 3 / 8,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: MediaQuery.of(context).size.height * 3 / 8,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: const Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 188, 252, 245),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Aquí va el contenido de la prueba',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: MediaQuery.of(context).size.height * 3 / 8,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color.fromARGB(255, 7, 71, 94),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppBar_Test1 extends StatelessWidget {
  const AppBar_Test1({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Test1',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
