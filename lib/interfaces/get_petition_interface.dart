import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/petition_model.dart';

abstract class IGetPetition {
  Future<List<PetitionModel>> getPetition(String api) async {
    final dio = Dio();

    Response response = await dio.get(api);
    if (response.statusCode == 200) {
      if (api.substring(0, 46) ==
          "https://mpt-petitions.ru/api/petitions/search/") {

        var getPetitionData = response.data as List;
        var listPetition =
        getPetitionData.map((petition) => PetitionModel.fromJson(petition)).toList();
        return listPetition;
      }
      else {
        var getPetitionData = response.data['data'] as List;
        var listPetition =
        getPetitionData.map((petition) => PetitionModel.fromJson(petition))
            .toList();
        return listPetition;
      }
    } else {
      throw Exception('Failed to load petitions');
    }
  }
}

abstract class IGetCountOfPetitions {
  Future<CountOfPetitions> getCountOfPetitions(String api) async {
    final dio = Dio();

    Response response = await dio.get(api);

    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      final body = response.data;
      return CountOfPetitions(
          countOfPages: body['last_page'].toString(),
          currentPage: body['current_page'].toString(),
          prevPageApi: body['prev_page_url'],
          nextPageApi: body['next_page_url']);
    } else {
      throw Exception('Failed to load petitions');
    }
  }
}