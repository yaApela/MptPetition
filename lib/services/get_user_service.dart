import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mpt_petitions/interfaces/get_user_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
String EMAIL = '';
String NAME = '';
String SURNAME = '';
String IMAGE = '';
int ID = 0;

void getData(Response response) async
{
  EMAIL = response.data['user']['email'];
  NAME = response.data['user']['name'];
  SURNAME = response.data['user']['surname'];
  ID = response.data['user']['id'];
  IMAGE = getImage(response.data['user']['image'])!;
}

String? getImage(String? image){
  final Uint8List base64;
  var imageResult;
  if (image != null) {
    base64 = base64Decode(image);
    imageResult = latin1.decode(base64);
    IMAGE = imageResult;
    return imageResult;
  } else {
    imageResult = null;
    return null;
  }
}

class GetUserService extends IGetUser {
  @override
  Future<UserModel?> getUser(SharedPreferences token) async {
    const api = "https://mpt-petitions.ru/api/user";
    final dio = Dio();

    dio.options.headers
        .addAll({"Authorization": "Bearer ${token.getString("token")}"});
    Response response = await dio.get(api);
    final Uint8List base64;
    final String? image = response.data['user']['image'];
    var imageResult;
    if (image != null) {
      print('image: $image');
      base64 = base64Decode(image);
      imageResult = latin1.decode(base64);
      print('imageResult: == $imageResult');
      IMAGE = imageResult;
    } else {
      imageResult = null;
      print('imageResult: == null');
    }
    print('User Info: ${response.data['user']['email']}');
    getData(response);
    if (response.statusCode == 200) {
      final body = response.data;

      print(body);
      if (body['message'] != 'unauthorized') {
        return UserModel.fromJson(body, token.getString("token"));
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
