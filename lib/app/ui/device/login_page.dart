import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;

    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Center(
          child: Container(
            width: larguraTela * 0.8,
            height: alturaTela * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                LoginHeader(
                  height: alturaTela * 0.2,
                  width: larguraTela * 0.8,
                ),
              ],
            ),
          ),
        ));
  }
}

class LoginHeader extends StatelessWidget {
  final double height;
  final double width;
  const LoginHeader({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/StockBackground-1472x980.jpg',
            fit: BoxFit.cover,
            color: Colors.purple.withOpacity(0.6),
            colorBlendMode: BlendMode.srcOver,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faça seu Login',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.white,
                thickness: 5,
                endIndent: width * 0.65,
              )
            ],
          ),
        ),
        Positioned(
          top: (height * 1) - 48,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/icons/EnhancedAppIcon.svg',
            height: 96,
          ),
        ),
      ],
    );
  }
}
