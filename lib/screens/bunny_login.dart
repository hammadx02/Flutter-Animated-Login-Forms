import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class BunnyLoginScreen extends StatefulWidget {
  const BunnyLoginScreen({Key? key}) : super(key: key);

  @override
  State<BunnyLoginScreen> createState() => _BunnyLoginScreenState();
}

class _BunnyLoginScreenState extends State<BunnyLoginScreen> {
  late String animationURL;
  Artboard? _teddyArtboard;
  SMITrigger? loginSuccessTrigger, loginFailTrigger;
  SMIBool? isFocus, isPassword;
  SMINumber? eyeTrack;

  bool _isChecked = false;

  StateMachineController? stateMachineController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationURL = defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/animations/bunny_login.riv'
        : 'animations/bunny_login.riv';

    rootBundle.load(animationURL).then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        stateMachineController =
            StateMachineController.fromArtboard(artboard, "State Machine 1");
        if (stateMachineController != null) {
          artboard.addController(stateMachineController!);

          for (var element in stateMachineController!.inputs) {
            if (element.name == "login_success") {
              loginSuccessTrigger = element as SMITrigger;
            } else if (element.name == "login_fail") {
              loginFailTrigger = element as SMITrigger;
            } else if (element.name == "isFocus") {
              isFocus = element as SMIBool;
            } else if (element.name == "IsPassword") {
              isPassword = element as SMIBool;
            } else if (element.name == "eye_track") {
              eyeTrack = element as SMINumber;
            }
          }
        }

        setState(() => _teddyArtboard = artboard);
      },
    );
  }

  void handleFocus() {
    isFocus?.change(true);
  }

  void handlePasswordFocus() {
    isFocus?.change(false);
    isPassword?.change(true);
    eyeTrack?.change(0);
  }

  void moveEyeTrack(val) {
    eyeTrack?.change(val.length.toDouble());
  }

  void login() {
    isPassword?.change(false);
    isFocus?.change(false);
    if (_emailController.text == "zain@gmail.com" &&
        _passwordController.text == "zain") {
      loginSuccessTrigger?.fire();
      // Trigger additional animation for success
      // Example: Increase scale or opacity (if applicable)
    } else {
      loginFailTrigger?.fire();
      // Trigger additional animation for failure
      // Example: Shake effect or color change (if applicable)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffd6e2ea),
        title: Text(
          '@zain_dev',
          style: GoogleFonts.aBeeZee(
              color: Color(0xffea552e),
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
      ),
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_teddyArtboard != null)
              SizedBox(
                width: 500, // Increased width
                height: 400, // Increased height
                child: Rive(
                  artboard: _teddyArtboard!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            Container(
              alignment: Alignment.center,
              width: 400,
              padding: const EdgeInsets.only(bottom: 15),
              margin: const EdgeInsets.only(bottom: 15 * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 15 * 2),
                        TextField(
                          controller: _emailController,
                          onTap: handleFocus,
                          onChanged: moveEyeTrack,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(fontSize: 14),
                          cursorColor: const Color(0xffea552e),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: GoogleFonts.aclonica(
                                fontSize: 14, fontWeight: FontWeight.w700),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusColor: const Color(0xffea552e),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffea552e),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _passwordController,
                          onTap: handlePasswordFocus,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: GoogleFonts.poppins(fontSize: 14),
                          cursorColor: const Color(0xffea552e),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: GoogleFonts.aclonica(
                                fontSize: 14, fontWeight: FontWeight.w700),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusColor: const Color(0xffea552e),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffea552e),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: Checkbox(
                                    activeColor: const Color(0xffea552e),
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  "Remember me",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffea552e),
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
