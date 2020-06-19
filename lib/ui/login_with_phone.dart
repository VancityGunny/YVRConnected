import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrfriends/blocs/authentication/auth_bloc.dart';
import 'package:yvrfriends/blocs/authentication/auth_event.dart';
import 'package:yvrfriends/blocs/authentication/auth_repository.dart';

class LoginOTP extends StatefulWidget {
  @override
  _LoginOTPState createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  String status;
  bool sent = false;
  String _verId;
  String _phoneNumber;
  String _smsCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Phone Authentication')),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Center(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // width: 200.0,
                        // height: 350.0,
                        margin: EdgeInsets.only(bottom: 40.0),
                        child: Image(
                          image: AssetImage(
                            'graphics/authentication.png',
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.grey,
                          ),
                          child: TextField(
                            // enabled: false,
                            enabled: !sent,
                            onChanged: (input) => _phoneNumber = input,
                            decoration: InputDecoration(
                              labelText: "Phone number",
                              hintText: "+00 000 000 000",
                            ),
                            keyboardType: TextInputType.phone,
                            // onChanged: (value) => _phoneNumber = value,
                          ),
                        ),
                      ),
                      sent
                          ? Container(
                              margin: EdgeInsets.only(top: 20.0),
                              height: 50.0,
                              child: Theme(
                                data: ThemeData(
                                  primaryColor: Colors.grey,
                                ),
                                child: TextField(
                                  onChanged: (input) => _smsCode = input,
                                  decoration: InputDecoration(
                                    labelText: "Verification code",
                                  ),
                                  keyboardType: TextInputType.phone,
                                  // onChanged: (value) => _phoneNumber = value,
                                ),
                              ),
                            )
                          : SizedBox(),
                      Container(
                        height: 50.0,
                        margin: EdgeInsets.only(top: 30.0),
                        width: double.infinity,
                        child: RaisedButton(
                          color: Color.fromRGBO(0, 191, 166, 1),
                          onPressed: !sent
                              ? () async {
                                  await sendCodeToPhoneNumber(_phoneNumber);
                                }
                              : () async {
                                  assert(_smsCode != null);
                                  assert(_verId != null);

                                  AuthCredential credential =
                                      PhoneAuthProvider.getCredential(
                                          verificationId: _verId,
                                          smsCode: _smsCode);
                                  BlocProvider.of<AuthBloc>(context).add(
                                    LogInWithPhonePressedEvent(
                                        credential, _phoneNumber),
                                  );
                                },
                          child: Text(
                              !sent ? "Send verification code" : "Confirm"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> sendCodeToPhoneNumber(_phoneNumber) async {
    // String output;
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      // setState(() {
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $phoneAuthCredential');
      BlocProvider.of<AuthBloc>(context).add(
        LogInWithPhonePressedEvent(phoneAuthCredential, _phoneNumber),
      );
      // showDialog(
      //     child: new AlertDialog(
      //       content: Text(
      //           'Can not send verification number, You may have exceed daily limit. Please try again in 24 hours. If Problem still persist please contact us at contact@zeusshard.com'),
      //     ),
      //     context: context);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      // setState(() {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      // showDialog(
      //     child: new AlertDialog(
      //       content: Text(authException.message),
      //     ),
      //     context: context);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verId = verificationId;
      setState(() {
        sent = true;
        // print('Code sent to $phone');
        status = "\nEnter the code sent to " + _phoneNumber;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // phoneVerificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    // if (phoneVerificationId != null) {
    //   _signInWithPhoneNumber("222222", phoneVerificationId);
    // }
  }
}
