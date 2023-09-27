import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:mpt_petitions/pages/password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/delete_user_interface.dart';
import '../interfaces/get_user_interface.dart';
import '../interfaces/update_password_interface.dart';
import '../interfaces/update_user_interface.dart';
import '../models/user_login_model.dart';
import '../models/user_model.dart';
import '../models/user_password_model.dart';
import '../services/delete_user_service.dart';
import '../services/get_user_service.dart';
import '../services/update_password_service.dart';
import '../services/update_user_service.dart';
import 'Custom_Wigets.dart';
import 'Petition.dart';
import 'authorization_page.dart';
import '../constants/global.dart' as global;

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/profile',
      routes: {
        '/profile': (context) => Profile(),
        '/password': (context) => Password(),
      },
    ),
  );
}

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  var HttpLog = ' https://mpt-petitions.ru/api/Login';

  final dio = Dio();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();

  final IGetUser _getUser = GetUserService();
  final UpdateUser _updateUser = UpdateUserService();
  final UpdatePassword _updatePassword = UpdatePasswordService();
  final DeleteUser _deleteUser = DeleteUserService();

  void dataSet() {
    setState(() {
      _nameController.text = NAME;
      _surnameController.text = SURNAME;
      _emailController.text = EMAIL;
    });
  }

  final style = const ButtonStyle(
    alignment: Alignment.center,
  );
  FilePickerResult? result;
  String? _fileName;
  Uint8List? pickedFile;
  bool isLoading = false;
  var _file;

  void _pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePickerWeb.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        _fileName = result!.files.first.name;
        print("load image profile: $_fileName");
        pickedFile = result!.files.single.bytes;
        _file = result?.files.single;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void startUpdate() async {
    UserLoginModel? userLogin;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("token");
    if (userLogin != null) {
      prefs.setString("token", userLogin.token);
      UserModel? user = await _getUser.getUser(prefs);
    }
  }

  @override
  Widget build(BuildContext context) {
    startUpdate();
    dataSet();
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBar_widget(),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      width: 180,
                      height: double.infinity,
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45,
                          ),
                          TextButton(
                              onPressed: () {},
                              style: style,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.account_circle,
                                    color: Color.fromARGB(255, 52, 64, 180),
                                  ),
                                  Text(
                                    'Профиль',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 52, 64, 180),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 22,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Password()));
                              },
                              style: style,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.key_rounded,
                                    color: Color.fromARGB(255, 122, 122, 122),
                                  ),
                                  Text(
                                    'Пароль',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 74, 73, 73),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 22,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Petitions()));
                              },
                              style: style,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.article_rounded,
                                    color: Color.fromARGB(255, 122, 122, 122),
                                  ),
                                  Text(
                                    'Мои петиции',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 74, 73, 73),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 246, 244, 238),
                        width: 500,
                        height: double.infinity,
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 35,
                              ),
                              const SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Text("Редактировать профиль",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35.0,
                                        color:
                                            Color.fromARGB(255, 4, 19, 165))),
                              ),
                              if (pickedFile != null)
                                Container(
                                  height: 150,
                                  width: 250,
                                  padding: EdgeInsets.zero,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image(
                                    image: MemoryImage(pickedFile!),
                                  ),
                                ),
                              if (pickedFile == null &&
                                  global.user.image == null)
                                Container(
                                  height: 150,
                                  width: 250,
                                  padding: EdgeInsets.zero,
                                  child: const Icon(Icons.add_a_photo),
                                ),
                              if (pickedFile == null &&
                                  global.user.image != null)
                                Container(
                                  height: 150,
                                  width: 250,
                                  padding: EdgeInsets.zero,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                      IMAGE),
                                ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                height: 50,
                                width: 150,
                                child: TextButton(
                                  onPressed: () {
                                    _pickFile();
                                  },
                                  child: const Text("Загрузить фото",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(255, 4, 19, 165))),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 270,
                                width: 350,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 350,
                                        child: TextFormField(
                                          controller: _nameController,
                                          validator: (value) {
                                            if (value == "")
                                              return "Заполните поле ввода имени";
                                          },
                                          decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 250, 232, 220),
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            hintText: 'Введите имя',
                                            contentPadding: EdgeInsets.only(
                                                left: 14.0,
                                                bottom: 0.0,
                                                top: 0.0),
                                            fillColor: Colors.white,
                                            filled: true,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Color.fromARGB(
                                                255, 254, 125, 99),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        width: 350,
                                        child: TextFormField(
                                          controller: _surnameController,
                                          validator: (value) {
                                            if (value == "")
                                              return "Заполните поле ввода фамилии";
                                          },
                                          decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 250, 232, 220),
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            hintText: 'Введите фамилию',
                                            contentPadding: EdgeInsets.only(
                                                left: 14.0,
                                                bottom: 0.0,
                                                top: 0.0),
                                            fillColor: Colors.white,
                                            filled: true,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Color.fromARGB(
                                                255, 254, 125, 99),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        width: 350,
                                        child: TextFormField(
                                          controller: _emailController,
                                          validator: (value) {
                                            if (value == "")
                                              return "Заполните поле ввода почты";
                                          },
                                          decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 250, 232, 220),
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 254, 125, 99),
                                                  width: 2.0),
                                            ),
                                            hintText: 'Введите почту  ',
                                            contentPadding: EdgeInsets.only(
                                                left: 14.0,
                                                bottom: 0.0,
                                                top: 0.0),
                                            fillColor: Colors.white,
                                            filled: true,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Color.fromARGB(
                                                255, 254, 125, 99),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 35,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text("Отправляю запрос")),
                                      );
                                      try {
                                        UserLoginModel? userLogin;
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.getString("token");

                                        UserModel? user =
                                            await _updateUser.update(
                                                ID,
                                                _surnameController.text,
                                                _nameController.text,
                                                _emailController.text,
                                                _file,
                                                prefs);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Изменение подтверждено!")));
                                        setState(() {
                                          EMAIL = _emailController.text;
                                          NAME = _nameController.text;
                                          SURNAME = _surnameController.text;
                                          startUpdate();
                                          IMAGE = global.user.image!;
                                        });
                                      } catch (e) {
                                        print(e.toString());
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  color: const Color.fromARGB(255, 52, 64, 180),
                                  child: const Text(
                                    'Сохранить',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text("Отменить",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(255, 4, 19, 165))),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                width: 250,
                                height: 35,
                                child: RaisedButton(
                                  onPressed: () async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Отправляю запрос")),
                                    );
                                    try {
                                      UserLoginModel? userLogin;
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.getString("token");
                                      await _deleteUser.delete(prefs);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthorizationPage()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Удаление подтверждено!")));
                                    } catch (e) {
                                      print(e.toString());
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  color: const Color.fromARGB(255, 52, 64, 180),
                                  child: const Text(
                                    'Удалить пользователя',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
