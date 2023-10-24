import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/users.dart';
import 'package:vendo/screens/auth/forget_password.dart';
import 'package:vendo/screens/main/main_screen.dart';
import 'package:vendo/utils/reusable_widgets.dart';

import '../../models/database_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Image.asset('images/logo_vendo_1.png', scale: 3),
            ),
            const SizedBox(height: 80),
            Text(
              'Welcome',
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            const SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hai vendo peep’s. Sebelum menggunakan '
                  'aplikasi vendo, ayo bikin akun dulu! ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF4B5563)),
                )),
            const SizedBox(height: 110),
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const AuthBottomSheet(
                            activeContent: 'Buat Akun');
                      });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF314797),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15)),
                child: Text('Buat Akun',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                    ))),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const AuthBottomSheet(activeContent: 'Login');
                      });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB2C4FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 12)),
                child: Text('Login',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2A4399)))),
          ],
        ),
      ),
    );
  }
}

class AuthBottomSheet extends StatefulWidget {
  const AuthBottomSheet({super.key, required this.activeContent});

  final String activeContent;

  @override
  State<StatefulWidget> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  late String _activeContent;

  @override
  void initState() {
    super.initState();
    _activeContent = widget.activeContent;
  }

  void setActiveContent() {
    setState(() {
      _activeContent = _activeContent == 'Buat Akun' ? 'Login' : 'Buat Akun';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0))),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 70,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                bottomSheetHeader(
                    'Buat Akun', _activeContent, setActiveContent),
                // const SizedBox(width: 80),
                bottomSheetHeader('Login', _activeContent, setActiveContent),
              ]),
              const SizedBox(height: 30),
              Expanded(
                  child: _activeContent == 'Buat Akun'
                      ? const CreateAccount()
                      : const Login())
            ],
          ),
        ));
  }
}

Widget bottomSheetHeader(
    String content, String activeContent, void Function() setActiveContent) {
  return activeContent == content
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {},
                child: Text(content,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF314797),
                    ))),
            const SizedBox(height: 3),
            const SizedBox(
              width: 70,
              height: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFF314797)),
              ),
            )
          ],
        )
      : TextButton(
          onPressed: () {
            setActiveContent();
          },
          child: Text(content,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF89909E),
              )));
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  final validEmail = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
  );
  final validPassword = RegExp(r"^(?=.*[0-9]).{8,}$");
  final validPhoneNumber = RegExp(r"^(\+62|62|0)8[1-9][0-9]{6,9}$");

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseService service = DatabaseService();
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isPhoneNumberValid = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Nama Lengkap',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        reusableTextField(
            "Masukkan nama lengkapmu", false, _fullNameTextController),
        const SizedBox(height: 20),
        Text(
          'Alamat Email',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        reusableTextField(
            "Contoh : namaemail@emailkamu.com", false, _emailTextController),
        _isEmailValid
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.only(top: 7),
                child: Text(
                  'Format email salah!',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                )),
        const SizedBox(height: 10),
        Text(
          'Password',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        reusableTextField(
            "Contoh : namaemail@emailkamu.com", true, _passwordTextController
        ),
        _isPasswordValid
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.only(top: 7),
                child: Text(
                  'Password minimal 8 Karakter & mengandung angka',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                )),
        const SizedBox(height: 10),
        Text(
          'Nomor telepon',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        _isPhoneNumberValid
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.only(top: 7),
                child: Text(
                  'Format nomor telepon salah!',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                )
              ),
        reusablePhoneTextField("Contoh: 082918282911", _phoneTextController),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: _passwordTextController.text.isEmpty ||
                    _emailTextController.text.isEmpty || _fullNameTextController.text.isEmpty
                    || _phoneTextController.text.isEmpty
                ? null
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    validEmail.hasMatch(_emailTextController.text)
                        ? setState(() {
                            _isEmailValid = true;
                          })
                        : setState(() {
                            _isEmailValid = false;
                          });
                    validPassword.hasMatch(_passwordTextController.text)
                        ? setState(() {
                            _isPasswordValid = true;
                          })
                        : setState(() {
                            _isPasswordValid = false;
                          });
                    validPhoneNumber.hasMatch(_phoneTextController.text)
                        ? setState(() {
                            _isPhoneNumberValid = true;
                          })
                        : setState(() {
                            _isPhoneNumberValid = false;
                          });
                    if (_isPasswordValid && _isEmailValid && _isPhoneNumberValid) {
                      auth
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        var user = Users(
                            fullName: _fullNameTextController.text,
                            email: _emailTextController.text,
                            productsOnCart: [],
                            favProducts: [],
                            phoneNumber: _phoneTextController.text
                        );
                        service.createNewUser(user, auth.currentUser!.uid);
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (route) => false);
                      });
                    }
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF314797),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 105, vertical: 12)),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text('Sign Up',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background))),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F4F4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.symmetric(vertical: 12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/ic_google.png', scale: 2.5),
                const SizedBox(width: 20),
                Text('Sign up dengan Google',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2A4399))),
              ],
            )),
        const SizedBox(height: 40),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom))
      ],
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isError = false;
  bool _isLoading = false;

  checkAuthentication() async {
    auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const MainScreen()),
                (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Alamat Email',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        reusableTextField("Masukkan email", false, _emailTextController),
        const SizedBox(height: 20),
        Text(
          'Password',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        reusableTextField("Masukkan password", true, _passwordTextController),
        _isError
            ? Text(
                'Email / Password kamu salah!',
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
              )
            : const SizedBox(),
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgetPassword()));
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A4399)),
              )),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: _passwordTextController.text.isEmpty ||
                    _emailTextController.text.isEmpty
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await auth.signInWithEmailAndPassword(email: _emailTextController.text,
                          password: _passwordTextController.text);
                      checkAuthentication();
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _isLoading = false;
                        _isError = true;
                      });
                    }
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF314797),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 105, vertical: 12)),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text('Login',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background))),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom))
      ],
    );
  }
}
