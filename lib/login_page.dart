import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yar_messenger/firebase_api.dart';
import 'package:yar_messenger/login_cubit.dart';
import 'navigation/navigation_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = 'yar@oce.com';
  String password = '123456';
  late final LoginCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoginCubit(context.read<FirebaseApi>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('YarMessenger')),
        body: BlocProvider(
          create: (context) => LoginCubit(context.read<FirebaseApi>()),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: email,
                  onSaved: (value) {
                    email = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  initialValue: password,
                  onSaved: (value) {
                    password = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                ElevatedButton(
                    onPressed: () {
                      _bloc.logInUserEvent(email, password);
                    },
                    child: const Text('Login')),
                const SizedBox(height: 20),
                login(),
                GestureDetector(
                  child: const Text('Not Registered yet?'),
                  onTap: () {
                    NavigationHelper.openSignUpPage(context);
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget login() {
    return BlocConsumer<LoginCubit, LoginStates>(
        bloc: _bloc,
        listener: (context, state) {
          print('state $state');
          if (state is LoggedSuccessState) {
            print('bloc/user ${_bloc.user}');
            NavigationHelper.openUsersListPage(context: context, bloc: _bloc);
          }
        },
        builder: (context, state) {
          if (state is LoggedErrorState) {
            return SizedBox(
              child: Text(state.error,
                  style:
                      const TextStyle(fontSize: 20, color: Colors.redAccent)),
              width: MediaQuery.of(context).size.width * 0.7,
            );
          }
          return Container();
        });
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpGlobalKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late String confirmPassword;
  late String displayName;
  late String phoneNumber;
  File? _image;

  late final LoginCubit _bloc;
  late final FirebaseApi _firebaseApi;

  @override
  void initState() {
    super.initState();
    _firebaseApi = FirebaseApi();
    _bloc = LoginCubit(_firebaseApi);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (context) => LoginCubit(_firebaseApi),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
          child: Form(
            key: _signUpGlobalKey,
            child: Row(children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 55),
                    TextFormField(
                        onSaved: (value) {
                          email = value!;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email')),
                    TextFormField(
                      controller: TextEditingController(text: '123456'),
                      onSaved: (value) => password = value!,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        controller: TextEditingController(text: '123456'),
                        onSaved: (value) {
                          confirmPassword = value!;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password')),
                    TextFormField(
                        controller: TextEditingController(text: 'yarshau'),
                        onSaved: (value) {
                          displayName = value!;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(labelText: 'Display Name')),
                    TextFormField(
                        controller: TextEditingController(text: '0932383265'),
                        onSaved: (value) {
                          phoneNumber = value!;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(labelText: 'Phone number')),
                    ElevatedButton(
                        onPressed: () {
                          if (_signUpGlobalKey.currentState!.validate()) {
                            final a = _signUpGlobalKey.currentState?.save();
                          }
                          _bloc.createNewUserEvent(email, password, phoneNumber,
                              displayName, _image);
                        },
                        child: const Text('Register')),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.height * 0.1),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        _getImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        color: Colors.grey,
                        child: showImage(),
//                        _image == null
//                            ? const Icon(Icons.image)
//                            : Image.file(_image!, fit: BoxFit.cover),
                      )),
                  BlocConsumer<LoginCubit, LoginStates>(
                    listener: (context, state) {
                      if (state is LoggedSuccessState) {
                        Navigator.pushReplacementNamed(
                            context, 'messaging_page');
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<LoginCubit, LoginStates>(
                          bloc: _bloc,
                          builder: (context, state) {
                            print('state is: $state');
                            if (state is LoggedErrorState) {
                              return Container(
                                  width: 200, child: Text(state.error));
                            } else if (state is ImageAddedState){
                              return Text('Image is added');
                            }
                            return const Text('Add your avatar');
                          });
                    },
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget showImage() {
    if (_image == null) {
      return const Icon(Icons.image);

    } else {
      return Image.file(_image!, fit: BoxFit.cover);
    }
  }

  Future _getImage() async {
    try {
      final _image = await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageTemporary = File(_image!.path);
      setState(() => this._image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
