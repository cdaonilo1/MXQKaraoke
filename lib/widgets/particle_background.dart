import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Color color;
  final int particleCount;

  const ParticleBackground({
    super.key,
    this.color = Colors.white,
    this.particleCount = 50,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initParticles();
  }

  void _initParticles() {
    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        x: _random.nextDouble() * 100,
        y: _random.nextDouble() * 100,
        size: _random.nextDouble() * 3 + 1,
      ),
    );

    _controllers = List.generate(
      widget.particleCount,
      (index) => AnimationController(
        duration: Duration(seconds: _random.nextInt(10) + 10),
        vsync: this,
      )..repeat(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a2942),
      child: Stack(
        children: List.generate(
          widget.particleCount,
          (index) => AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              final value = _controllers[index].value;
              final dx = sin(value * 2 * pi) * 50;
              final dy = cos(value * 2 * pi) * 50;
              final opacity = 0.3 + (sin(value * 2 * pi) + 1) / 2 * 0.4;

              return Positioned(
                left: MediaQuery.of(context).size.width * _particles[index].x / 100 + dx,
                top: MediaQuery.of(context).size.height * _particles[index].y / 100 + dy,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: _particles[index].size,
                    height: _particles[index].size,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;

  Particle({required this.x, required this.y, required this.size});
}
