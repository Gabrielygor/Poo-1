import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum TableStatus { idle, loading, ready, error }


/* Receita 08 - 1

API usada no exercicio
https://random-data-api.com/api/cannabis/random_cannabis  

bool = só tem valores false or true

OBS: não coloquei a função de PopupMenuButton igual a receita anterior

*/


class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier(
      {'status': TableStatus.idle, 'dataObjects': [], 'columnNames': []});

  //Funções de carregamento

  void carregar(index) {
    final funcoes = [
      makeCoffee,
      makeBeer,
      makeNations,
      makeCannabis
    ];

    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'columnNames': [],
    };

    funcoes[index]();
  }

  //Metodo de consumir API visto no Youtube 
  //"https://www.youtube.com/watch?v=rLUH5xyO_Ao&ab_channel=WilliamSilva"
  
  void makeCoffee() {
    var coffeesUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/coffee/random_coffee',
        queryParameters: {'size': '8'});
    try {
      http.read(coffeesUri).then((jsonString) {
        var coffeesJson = jsonDecode(jsonString);

        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': coffeesJson,
          'columnNames': ["Blend Name", "Origin", "Variety"],
          'propertyNames': ["blend_name", "origin", "variety"]
        };
      });
    } catch (err) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    }
  }

  Future<void> makeNations() async {
    var nationsUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/nation/random_nation',
        queryParameters: {'size': '8'});

    try {
      var jsonString = await http.read(nationsUri);

      var nationsJson = jsonDecode(jsonString);

      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': nationsJson,
        'columnNames': ["Nationality", "Language", "Capital"],
        'propertyNames': ["nationality", "language", "capital"]
      };
    } catch (err) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    }
  }

  void makeBeer() {
    var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '8'});

    try {
      http.read(beersUri).then((jsonString) {
        var beersJson = jsonDecode(jsonString);

        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': beersJson,
          'columnNames': ["Nome", "Estilo", "IBU"],
          'propertyNames': ["name", "style", "ibu"]
        };
      });
    } catch (err) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    }
  }

  void makeCannabis() {
    var cannabisUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/cannabis/random_cannabis',
        queryParameters: {'size': '8'});

    http.read(cannabisUri).then((jsonString) {
      var cannabisJson = jsonDecode(jsonString);

      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': cannabisJson,
        'columnNames': ["Strain", "Health Benefits", "Abbreviation"],
        'propertyNames': ["strain", "health_benefit", "cannabinoid_abbreviation"]
      };
    });
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Utilizando APIS"),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: dataService.tableStateNotifier,
                  builder: (_, value, __) {
                    switch (value['status']) {
                      case TableStatus.idle:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: const [
                                Text(
                                  "1. Toque em um dos botões abaixo",
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "para executar o aplicativo.",
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.arrow_drop_down_rounded)
                              ],
                            ),
                          ],
                        );

                      case TableStatus.loading:
                        return CircularProgressIndicator();

                      case TableStatus.ready:
                        return DataTableWidget(
                            jsonObjects: value['dataObjects'],
                            propertyNames: value['propertyNames'],
                            columnNames: value['columnNames']);

                      case TableStatus.error:
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Erro ao Carregar. FUDEU",
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.center,
                              ),
                              Icon(Icons.error)
                            ]);
                    }

                    return Text("...");
                  }),
            ],
          )),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          state.value = index;

          _itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Coffee",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Beers", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nations", icon: Icon(Icons.flag_outlined)),
          BottomNavigationBarItem(label: "Cannabis", icon: Icon(Icons.forest))
        ]);
  }
}


//Configura a tabela 
//Ordem Alfabetica (criterio de ordenação do exercicio)
//Codigo adaptado com a ajuda do video abaixo 
//https://www.youtube.com/watch?v=XNU3hX3QFeE&ab_channel=Prof.DiegoAntunes
class DataTableWidget extends HookWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const ["Nome", "Estilo", "IBU"],
      this.propertyNames = const ["name", "style", "ibu"]});

  dynamic _compareMaker(String property, bool asc) {
    return asc
        ? (a, b) => a[property].compareTo(b[property]) as int
        : (a, b) => b[property].compareTo(a[property]) as int;
  }

  @override
  Widget build(BuildContext context) {
    var internalState = useState({
      'asc': true,
      'sortColumn': null,
      'objects': jsonObjects,
    });

    return SingleChildScrollView(
        child: DataTable(
            sortAscending: internalState.value['asc'] as bool,
            sortColumnIndex: internalState.value['sortColumn'] != null
                ? internalState.value['sortColumn'] as int
                : null,
            columns: columnNames
                .map((name) => DataColumn(
                    onSort: (index, isAscending) {
                      final compare =
                          _compareMaker(propertyNames[index], isAscending);
                      jsonObjects.sort(compare);
                      internalState.value = {
                        'objects': jsonObjects,
                        'sortColumn': index,
                        'asc': isAscending
                      };
                    },
                    label: Expanded(
                        child: Text(name,
                            style: TextStyle(fontStyle: FontStyle.italic)))))
                .toList(),
            rows: jsonObjects
                .map((obj) => DataRow(
                    cells: propertyNames
                        .map((propName) => DataCell(Text(obj[propName])))
                        .toList()))
                .toList()));
  }
}