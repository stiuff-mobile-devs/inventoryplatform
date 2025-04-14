import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventoryplatform/app/ui/device/pages/login_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.purple,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        AnimatedSplashScreen(
          duration: 5000,
          splash: SvgPicture.asset(
            'assets/icons/JustLogoColetor.svg',
          ),
          nextScreen:  const LoginPage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.transparent,
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
          ),
        ),
      ],
    );
  }
}
