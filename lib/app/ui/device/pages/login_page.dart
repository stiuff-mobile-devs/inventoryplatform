import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/login_controller.dart';
import 'package:inventoryplatform/app/ui/device/theme/credentials_model.dart';
import 'package:inventoryplatform/app/ui/device/theme/google_login_button.dart';
import 'package:inventoryplatform/app/ui/device/theme/loading_dialog.dart';
import 'package:inventoryplatform/app/ui/device/theme/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollHint = false;
  final controller = Get.find<LoginController>();

  void updateScrollHint() {
    if (!_scrollController.hasClients) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;

    if (maxScrollExtent > 0) {
      setState(() {
        _showScrollHint = currentOffset < maxScrollExtent - 20;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(updateScrollHint);
    WidgetsBinding.instance.addPostFrameCallback((_) => updateScrollHint());
    controller.checkLoginStatus(context);
  }

  @override
  void dispose() {
    _scrollController.removeListener(updateScrollHint);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OrientationBuilder(
              builder: (context, orientation) {
                return _buildContent(orientation);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Orientation orientation) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.8125,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: orientation == Orientation.portrait
          ? _buildPortraitContent(screenWidth, screenHeight)
          : _buildLandscapeContent(screenWidth * 0.35),
    );
  }

  Widget _buildPortraitContent(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              LoginHeader(width: screenWidth * 0.8, height: screenHeight * 0.2),
              SizedBox(height: screenHeight * 0.075),
              _buildTitleSection(),
              _buildLoginDetails(Orientation.portrait, screenWidth * 0.8),
            ],
          ),
          Positioned(
            top: (screenHeight * 0.2) - 48,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/EnhancedAppIcon.svg',
              height: 96,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeContent(double availableWidth) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: _buildLoginDetails(
                          Orientation.landscape,
                          availableWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showScrollHint)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: AnimatedOpacity(
                    opacity: _showScrollHint ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                      size: 32,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
              image: DecorationImage(
                image: const AssetImage(
                  'assets/images/StockBackground-1472x980.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.purple.withOpacity(0.6),
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/EnhancedAppIcon.svg',
                  height: 96,
                ),
                _buildTitleSection(isWhite: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection({bool isWhite = false}) {
    final textStyle = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'Inventário Universal',
          style: textStyle.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isWhite ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Gerencie seus itens de inventário em um ambiente compartilhado.',
          style: textStyle.bodyMedium?.copyWith(
            color: isWhite ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginDetails(Orientation orientation, double availableWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        orientation == Orientation.landscape
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Text(
                'Faça o seu login.',
                style:
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 3,
                width: 190,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),

                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDivider(availableWidth),
              _buildDivider(availableWidth),
            ],
          ),
        ),
        GoogleLoginButton(onPressed: _handleGoogleSignIn),
      ],
    );
  }


  Widget _buildDivider(double availableWidth) {
    return Container(
      width: availableWidth * 0.175,
      height: 2.5,
      color: const Color.fromARGB(90, 87, 87, 87),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    _showLoadingDialog(context);

    final bool success = await controller.handleGoogleSignIn();

    if (mounted && !success) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleSignIn(UserCredentialsModel credentials) async {
    _showLoadingDialog(context);

    final bool success = await controller.handleSignIn(credentials);

    if (mounted && !success) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
  }
}
