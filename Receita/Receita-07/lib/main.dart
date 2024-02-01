import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int quantidadeControle = 5; //Variavel par contorle de quantidade
int indexPadrao = 1;

/* Receita 07

  Referencia do PopupMenuButton (meunu de 3 pontos na NewNavBar)
  https://www.youtube.com/watch?v=JZeUtI9Is18&ab_channel=FlutterMapp  

*/


class DataService { 
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);
  var chaves = ["name", "style", "ibu"];
  var colunas = ["Nome", "Estilo", "IBU"];

  void carregar(index) {
    var funcoes = [
      carregarCafe,
      carregarCervejas,
      carregarNacoes,
    ];

    indexPadrao = index;

    funcoes[index]();
  }

  void mudarQuant(quantidade) {
    quantidadeControle = quantidade;
    carregar(indexPadrao);
  }

  void carregarCervejas() async {
    chaves = ["name", "style", "ibu"];
    colunas = ["Nome", "Estilo", "IBU"];

    var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '$quantidadeControle'});

    var jsonString = await http.read(beersUri);

    var beersJson = jsonDecode(jsonString);

    tableStateNotifier.value = beersJson;
  }

  void carregarCafe() async {
    chaves = ["blend_name", "origin", "variety"];
    colunas = ["Nome", "Origem", "Variedade"];

    var cafeUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/coffee/random_coffee',
        queryParameters: {'size': '$quantidadeControle'});

    var jsonString = await http.read(cafeUri);

    var cafeJson = jsonDecode(jsonString);

    tableStateNotifier.value = cafeJson;
  }

  void carregarNacoes() async {
    chaves = ["nationality", "language", "capital"];
    colunas = ["Nome", "Língua", "Capital"];

    var nacoesUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/nation/random_nation',
        queryParameters: {'size': '$quantidadeControle'});

    var jsonString = await http.read(nacoesUri);

    var nacoesJson = jsonDecode(jsonString);

    tableStateNotifier.value = nacoesJson;
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
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: MyAppBar(),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return DataTableWidget(
                  jsonObjects: value,
                  propertyNames: dataService.chaves,
                  columnNames: dataService.colunas,
                );
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback; 

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Coffee",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Beer", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "nations", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;

  final List<String> columnNames;

  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const ["Nome", "Estilo", "IBU"],
      this.propertyNames = const ["name", "style", "ibu"]});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
          columns: columnNames
              .map((name) => DataColumn(
                  label: Expanded(
                      child: Text(name,
                          style: TextStyle(fontStyle: FontStyle.italic)))))
              .toList(),
          rows: jsonObjects
              .map((obj) => DataRow(
                  cells: propertyNames
                      .map((propName) => DataCell(Text(obj[propName])))
                      .toList()))
              .toList()),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Consume APIS"),
      actions: [
        PopupMenuButton(
          onSelected: (quantidade) {
            dataService.mudarQuant(quantidade);
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            return menuControle(); //função que retorna a quantidad
          },
        )
      ],
    );
  }

  //Menu para definir quantidade de elementos na tela
  menuControle() { 
    return const [
      PopupMenuItem(
        value: 5,
        child: Text('5'),
      ),
      PopupMenuItem(
        value: 10,
        child: Text('10'),
      ),
      PopupMenuItem(
        value: 15,
        child: Text('15'),
      ),
    ];
  }
}