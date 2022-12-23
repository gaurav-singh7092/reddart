import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/Loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/feature/auth/controller/auth_controller.dart';
import '../../../core/common/sign_in_button.dart';
import 'package:rive/rive.dart';
import '../../../theme/pallete.dart';
class LoginScreen extends ConsumerStatefulWidget {
  final bool isFromLogin;
  const LoginScreen({super.key,this.isFromLogin = true});
  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context,isFromLogin);
  }
  void SignInAsGuest(WidgetRef ref, BuildContext context) {
    ref.watch(authControllerProvider.notifier).signInAsGuest(context);
  }
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void SignInAsGuest(WidgetRef ref, BuildContext context) {
    ref.watch(authControllerProvider.notifier).signInAsGuest(context);
  }
  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context,widget.isFromLogin);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: isLoading? const Loader() : Stack(
        children: [
          const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
          Positioned.fill(
              child: BackdropFilter(
                filter:
                ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 10),
                child: const SizedBox(),
              )
          ),
          Positioned(
            height: 200,
              left: 30,
              top: 150,
              child: Image.asset('assets/images/logo.png')
          ),
          Positioned(
            left: 30,
            top: 300,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: SizedBox(
                        width: 260,
                        child: Column(
                          children:  [
                            const Text('Dive into anything.',
                            style: TextStyle(
                               fontSize: 40,
                              fontFamily: "Poppins",
                              height: 1.2
                            ),
                            ),
                            const SizedBox(height: 80,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                onPressed: () => signInWithGoogle(context, ref),
                                icon: Image.asset(
                                  Constants.googlePath,
                                  width: 45,
                                ),
                                label: Text(
                                  'Continue with Google',
                                  style: TextStyle(fontSize: 18,color: currentTheme.backgroundColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: currentTheme.primaryColor,
                                    minimumSize: const Size(double.infinity, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                                padding: const EdgeInsets.all(8),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.arrow_forward_ios_outlined,color: currentTheme.backgroundColor,),
                                onPressed: () => SignInAsGuest(ref, context),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: currentTheme.primaryColor,
                                    minimumSize: const Size(double.infinity, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                label: Text('Skip for Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: currentTheme.backgroundColor
                                  ),
                                ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
