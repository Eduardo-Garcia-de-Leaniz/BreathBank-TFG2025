import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showAppBar;
  final bool isScrollable;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool withAnimation;
  final EdgeInsetsGeometry padding;
  final bool canGoBack; // 👈 nuevo parámetro

  const BaseScreen({
    super.key,
    this.title,
    required this.child,
    this.showAppBar = true,
    this.isScrollable = false,
    this.actions,
    this.centerTitle = false,
    this.withAnimation = true,
    this.padding = const EdgeInsets.all(0),
    this.canGoBack = true, // 👈 valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.03;
    final double verticalPadding = screenHeight * 0.05;

    final padding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );

    Widget content = Padding(padding: padding, child: child);

    if (isScrollable) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    if (withAnimation) {
      content = _AnimatedScreen(child: content);
    }

    return WillPopScope(
      onWillPop: () async => canGoBack, // 👈 intercepta botón físico
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 188, 252, 245),
        appBar:
            showAppBar
                ? AppBar(
                  automaticallyImplyLeading:
                      canGoBack, // 👈 oculta flecha si false
                  title: Text(
                    title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                  centerTitle: centerTitle,
                  backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                  actions: actions,
                  elevation: 0,
                )
                : null,
        body: content,
      ),
    );
  }
}

/// Animación de entrada: Fade + Slide + Escala
class _AnimatedScreen extends StatefulWidget {
  final Widget child;

  const _AnimatedScreen({required this.child});

  @override
  State<_AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<_AnimatedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 600,
      ), // Duración extendida para más suavidad
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    ); // Agregamos escala suave

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}
