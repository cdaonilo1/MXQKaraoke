import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Color color;
  final int particleCount;

  const ParticleBackground({
    Key? key,
    this.color = const Color(0x80FFFFFF),
    this.particleCount = 50,
  }) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<ParticleData> particles;
  late List<AnimationController> controllers;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  void _initializeParticles() {
    final random = Random();
    particles = List.generate(
      widget.particleCount,
      (i) => ParticleData(
        id: i,
        x: random.nextDouble() * 100,
        y: random.nextDouble() * 100,
        size: random.nextDouble() * 3 + 1,
      ),
    );

    controllers = particles.map((particle) {
      return AnimationController(
        duration: Duration(seconds: random.nextInt(10) + 10),
        vsync: this,
      )
        ..forward()
        ..addListener(() {
          if (mounted) setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controllers[particle.id].reverse();
          } else if (status == AnimationStatus.dismissed) {
            controllers[particle.id].forward();
          }
        });
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: particles.map((particle) {
          final animation = controllers[particle.id];
          final position = Tween(
            begin: Offset(particle.x, particle.y),
            end: Offset(
              particle.x + (Random().nextDouble() * 100 - 50),
              particle.y + (Random().nextDouble() * 100 - 50),
            ),
          ).animate(animation);

          final opacity = Tween(
            begin: 0.3,
            end: 0.7,
          ).animate(animation);

          return Positioned(
            left: position.value.dx,
            top: position.value.dy,
            child: Opacity(
              opacity: opacity.value,
              child: Container(
                width: particle.size,
                height: particle.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ParticleData {
  final int id;
  final double x;
  final double y;
  final double size;

  ParticleData({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
  });
}
