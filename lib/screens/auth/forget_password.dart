import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/reusable_widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<StatefulWidget> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late EmailAuth emailAuth;
  final TextEditingController _emailTextController = TextEditingController();
  final validEmail = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
  var remoteServerConfiguration = {
    "server": "https://gustavo-smtp.azurewebsites.net",
    "serverKey": "kes7Uo"
  };

  @override
  void initState() {
    super.initState();
    emailAuth = EmailAuth(sessionName: "Sample session");
    emailAuth.config(remoteServerConfiguration);
  }

  void sendOtp() async {
    var res = await emailAuth.sendOtp(recipientMail: _emailTextController.text, otpLength: 5);
    if (res) {
      debugPrint("OTP sent");
    } else {
      debugPrint("Gabisa bangsaatt");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 150),
            Text(
                'Forget Password?',
                style: GoogleFonts.inter(
                    fontSize: 22, fontWeight: FontWeight.bold
                )
            ),
            Text(
                'Enter your registered email down below',
                style: GoogleFonts.inter(
                    fontSize: 16, color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500
                )
            ),
            const SizedBox(height: 60),
            Text(
                'Email address',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600
                )
            ),
            const SizedBox(height: 7),
            reusableTextField(
                "Contoh : namaemail@emailkamu.com", false, _emailTextController
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 60),
                    child: ElevatedButton(
                        onPressed: () {
                                sendOtp();
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF314797),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 105, vertical: 20
                            )
                        ),
                        child: Text('Submit',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background)
                        )
                    )
                )
            )
          ],
        )
      )
    );
  }
}