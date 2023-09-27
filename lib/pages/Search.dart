import 'package:flutter/material.dart';
import 'package:mpt_petitions/pages/Create_Petition.dart';
import 'package:mpt_petitions/pages/Custom_Wigets.dart';
import 'package:mpt_petitions/pages/Petition.dart';
import 'package:mpt_petitions/pages/Profile.dart';
import 'package:mpt_petitions/pages/View_petitions.dart';
import 'package:mpt_petitions/pages/password_page.dart';

import '../constants/constants.dart';
import '../interfaces/get_petition_interface.dart';
import '../models/petition_model.dart';
import '../services/get_petition_service.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/search',
      routes: {
        '/password': (context) => Password(),
        '/profile': (context) => Profile(),
        '/petition': (context) => Petitions(),
        '/create': (context) => const CreatePetition(),
        '/view': (context) => View_petition(),
        '/search': (context) => Search(),
      },
    ),
  );
}

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final style = const ButtonStyle(
    alignment: Alignment.center,
  );

  String api = "https://mpt-petitions.ru/api/petitions/search/";
  final IGetPetition _getPetition = GetPetitionService();
  final IGetCountOfPetitions _getCountOfPetitions =
  GetCountOfPetitionsService();
  var listPetitions;
  var listButtons;
  String numder = '';
  @override
  void initState() {
    super.initState();
    // listPetitions = _getPetition.getPetition('https://mpt-petitions.ru/api/petitions/search/дистант1');
//    listButtons = _getCountOfPetitions.getCountOfPetitions('https://mpt-petitions.ru/api/petitions/most-popular?page=1');
  }

  void upd()
  {
    setState(() {
      numder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            //  color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(children: [
                AppBar_widget(),
                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 600,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _searchController,
                          validator: (value) {
                            if (value == "") return "Заполните поле ввода имени";
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 254, 125, 99),
                                  width: 2.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 254, 125, 99),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 250, 232, 220),
                                  width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 254, 125, 99),
                                  width: 2.0),
                            ),
                            hintText: 'Поиск петиции...',
                            contentPadding:
                            EdgeInsets.only(left: 14.0, bottom: 0.0, top: 0.0),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Color.fromARGB(255, 254, 125, 99),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        width: 80,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () {
                            if(_searchController.text != '' && _searchController.text != "") {
                              setState(() {
                                listPetitions = _getPetition
                                    .getPetition(api + _searchController.text);
                                listButtons =
                                    _getCountOfPetitions.getCountOfPetitions(
                                        api + _searchController.text);
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: const Color.fromARGB(255, 255, 142, 106),
                          child: const Text(
                            'Поиск',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (listPetitions != '' &&
                    listPetitions != null &&
                    listPetitions != api)
                  SizedBox(
                    width: 910,
                    child: FutureBuilder<List<PetitionModel>>(
                      future: listPetitions,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var petition =
                                  (snapshot.data as List<PetitionModel>)[index];
                                  return Petition_widget_ViewPetitions(
                                    id: petition.id.toString(),
                                    pickedFile: petition.image,
                                    name: petition.name,
                                    description: petition.description,
                                    created_at: petition.created_at,
                                    signatures: petition.signatures.toString(),
                                    nameAuthor: petition.nameAuthor.toString(),
                                    surnameAuthor: petition.surnameAuthor.toString(),
                                    superStringCurrentWindow: "ViewPetitions",
                                    backgroundPetitionColor:
                                    ConstantValues.backgroundPetitionColor,
                                    onUpdateSelected: () async {
                                      listPetitions = _getPetition.getPetition(api + _searchController.text);
                                      setState(() {
                                        listPetitions = _getPetition.getPetition(api + _searchController.text);
                                      });
                                    },
                                  );
                                },
                                itemCount: (snapshot.data as List<PetitionModel>).length),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                const SizedBox(
                  height: 40,
                ),

              ])),
        ));
  }
}
