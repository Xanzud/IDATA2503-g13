import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/pages/feed_page.dart';
import 'package:project/pages/feed_page_admin.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  String? email = "";
  String? username = "";
  String? password = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildContent(context),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_validateAndSaveForm()) {
      try {
        await auth.signInWithEmailAndPassword(
            email: email!, password: password!);

        /*
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseCrud.getUserByUid(
                  FirebaseAuth.instance.currentUser!.uid)
              .then((value) {
            if (value.role == "admin") {
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (context) => new FeedPage()),
                  (route) => false);
            }
          });
        }
        */
        if (FirebaseAuth.instance.currentUser!.email == "admin@admin.com") {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (context) => new LandingPageAdmin()),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new FeedPage()),
              (route) => false);
        }
      } on FirebaseAuthException catch (err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message!)));
        //Utils.showSnackBar(err.message, Colors.red);
      }
    }
  }

  Widget _buildContent(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(25),
        color: Colors.white,
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Center(
                  child: Column(children: [
                    SizedBox(height: 20),
                    SizedBox(child: Image.asset("images/icon01.png")),
                    SizedBox(height: 100),
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            validator: (value) => value!.isNotEmpty
                                ? null
                                : 'Enter a valid email',
                            decoration: InputDecoration(labelText: 'Email'),
                            onSaved: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            validator: (value) => value!.isNotEmpty
                                ? null
                                : 'Password can\'t be empty',
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            onSaved: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                _submit(context);
                              },
                              child: Text("Login"),
                            ))
                      ],
                    )
                  ]),
                ))
          ],
        ));
  }
}
