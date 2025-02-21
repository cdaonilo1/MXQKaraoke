import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  final List<ParticleModel> particles = [];
  final int particleCount = 50;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize particles
    for (int i = 0; i < particleCount; i++) {
      particles.add(ParticleModel());
    }

    // Setup animation
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        for (var particle in particles) {
          particle.update();
        }
        setState(() {});
      });

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(particles),
      child: const SizedBox.expand(),
    );
  }
}

class ParticleModel {
  late double x;
  late double y;
  late double speed;
  late double theta;
  late double size;

  final random = Random();

  ParticleModel() {
    reset();
    x = random.nextDouble() * 100;
    y = random.nextDouble() * 100;
  }

  void reset() {
    x = random.nextDouble() * 100;
    y = random.nextDouble() * 100;
    speed = random.nextDouble() * 0.3 + 0.1;
    theta = random.nextDouble() * 2 * pi;
    size = random.nextDouble() * 2 + 1;
  }

  void update() {
    x += speed * cos(theta);
    y += speed * sin(theta);

    if (x < 0 || x > 100 || y < 0 || y > 100) {
      reset();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final position = Offset(
        particle.x * size.width / 100,
        particle.y * size.height / 100,
      );
      canvas.drawCircle(position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}