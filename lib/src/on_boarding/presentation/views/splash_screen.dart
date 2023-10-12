import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Set the desired duration
      vsync: this, // Add a TickerProvider, typically a State object
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward().then((value) {
      _controller.animateBack(0,duration:  const Duration(milliseconds: 1000))
          .then((_){
        Navigator.pushNamed(context, '/default');
      });
    }); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
        opacity: _animation
        ,child: Image.asset(MediaRes.logoTrans,
        height: MediaQuery.of(context).size.height*0.35,
        width: MediaQuery.of(context).size.height*0.35,
        ),),
      ),
    );
  }
}
