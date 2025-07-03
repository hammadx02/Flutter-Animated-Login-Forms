import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class ManLoginScreen extends StatefulWidget {
  const ManLoginScreen({Key? key}) : super(key: key);

  @override
  State<ManLoginScreen> createState() => _ManLoginScreenState();
}

class _ManLoginScreenState extends State<ManLoginScreen> {
  late String animationURL;
  Artboard? _teddyArtboard;
  SMITrigger? sucess, fail;
  SMIBool? glassesOn, Check;
  SMINumber? look;

  bool _isChecked = false;

  StateMachineController? stateMachineController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationURL = defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/animations/man_login.riv'
        : 'animations/man_login.riv';

    rootBundle.load(animationURL).then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(artboard, "State Machine 1");
      if (stateMachineController != null) {
        artboard.addController(stateMachineController!);

        for (var element in stateMachineController!.inputs) {
          if (element.name == "sucess") {
            sucess = element as SMITrigger;
          } else if (element.name == "fail") {
            fail = element as SMITrigger;
          } else if (element.name == "glasses_on") {
            glassesOn = element as SMIBool;
          } else if (element.name == "Check") {
            Check = element as SMIBool;
          } else if (element.name == "look") {
            look = element as SMINumber;
          }
        }
      }

      setState(() => _teddyArtboard = artboard);
    });
  }

  void handleFocus() {
    Check?.change(true);
    glassesOn?.change(false); // Reset glasses on state when focusing
  }

  void handlePasswordFocus() {
    Check?.change(false);
    glassesOn?.change(true);
    look?.change(0); // Reset eye tracking when focusing on password
  }

  void moveEyeTrack(val) {
    look?.change(val.length.toDouble());
  }

  void login() {
    Check?.change(false);
    glassesOn?.change(false);
    if (_emailController.text == "hammad@gmail.com" &&
        _passwordController.text == "hammad") {
      sucess?.fire();
    } else {
      fail?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff313131),
      ),
      backgroundColor: const Color(0xff313131),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_teddyArtboard != null)
              SizedBox(
                width: 500, // Adjusted width
                height: 400, // Adjusted height
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
                color: Color(0xffd7d9f4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 30), // Space before TextField
                        TextField(
                          controller: _emailController,
                          onTap: handleFocus,
                          onChanged: moveEyeTrack,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(fontSize: 14),
                          cursorColor: const Color(0xff000458),
                          decoration: const InputDecoration(
                            hintText: "Email",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusColor: Color(0xff000458),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff000458),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
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
                          cursorColor: const Color(0xff000458),
                          decoration: const InputDecoration(
                            hintText: "Password",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusColor: Color(0xff000458),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff000458),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
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
                                Checkbox(
                                  activeColor: const Color(0xff000458),
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
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
                                backgroundColor: const Color(0xff000458),
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
