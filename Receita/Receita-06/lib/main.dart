import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/* Receita 6

Alteração no arquivo de dependencias 

 */


class DataService{

  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);
  var chaves = ["name","style","ibu"];
  var colunas = ["Nome", "Estilo", "IBU"];

  void carregar(index){
    var funcoes = [
      carregarCafe,

      carregarCervejas,

      carregarNacoes,

    ];

    funcoes[index]();

  }


//Ideia para fragmentar mais o codigo (aplicado apenas na cerveja)
  void defCerveja() {
    chaves = ["name","style","ibu"];
    colunas = ["Nome", "Estilo", "IBU"];

  }

  void carregarCervejas(){
    
    defCerveja();

    tableStateNotifier.value = [{

            "name": "La Fin Du Monde",

            "style": "Bock",

            "ibu": "65"

            },

            {

            "name": "Sapporo Premiume",

            "style": "Sour Ale",

            "ibu": "54"

            },

            {

            "name": "Duvel", 

            "style": "Pilsner", 

            "ibu": "82"

            }

          ];

    }

  void carregarCafe(){

    chaves = ["name","tipo","sab"];
    colunas = ["Nome", "Tipo", "Sabor"];

    tableStateNotifier.value = [{

            "name": "Café Acaiá",

            "tipo": "gelado",

            "sab": "XXXXX"

            },

            {

            "name": "Café Robusta",

            "tipo": "quente",

            "sab": "XXXXX"

            },

            {

            "name": "Café Kona", 

            "tipo": "quente",

            "sab": "XXXXX"

            }

          ];

    }

  void carregarNacoes(){

    chaves = ["name","moeda","hab"];
    colunas = ["Nome", "Moeda", "Habitantes"];

    tableStateNotifier.value = [{

            "name": "Brasil",

            "moeda": "Real",

            "hab": "Muitos"

            },

            {

            "name": "Eslováquia",

            "moeda": "Euros",

            "hab": "Alguns"

            },

            {

            "name": "China",

            "moeda": "Yuan chinês",

            "hab": "Pra KRLH"

            }

          ];

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

      theme: ThemeData(primarySwatch: Colors.teal),

      debugShowCheckedModeBanner:false,

      home: Scaffold(

        appBar: AppBar( 

          title: const Text("XXXXXXXX"),

          ),

        body: ValueListenableBuilder(

          valueListenable: dataService.tableStateNotifier,

          builder:(_, value, __){

            return DataTableWidget(

              jsonObjects: value, 

              propertyNames: dataService.chaves, 

              columnNames: dataService.colunas,


            );

          }

        ),

        //Passa qual o botao foi apertado 
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),

      ));

  }

}

class NewNavBar extends HookWidget {

  var itemSelectedCallback; //Variavel para retorna o botao clicado

  NewNavBar({this.itemSelectedCallback}){

    itemSelectedCallback ??= (_){} ;

  } 

  @override

  Widget build(BuildContext context) {

    var state = useState(1);

    return BottomNavigationBar(

      onTap: (index){

        state.value = index;
        itemSelectedCallback(index);
         
      }, 

      currentIndex: state.value,

      items: const [

        BottomNavigationBarItem(

          label: "coffee",

          icon: Icon(Icons.coffee_outlined),

        ),

        BottomNavigationBarItem(

            label: "beer", icon: Icon(Icons.local_drink_outlined)),

        BottomNavigationBarItem(label: "nations", icon: Icon(Icons.flag_outlined))

      ]);

  }

}

class DataTableWidget extends StatelessWidget {

  final List jsonObjects;

  final List<String> columnNames;

  final List<String> propertyNames;

  DataTableWidget( {this.jsonObjects = const [], this.columnNames = const ["Nome","Estilo","IBU"], this.propertyNames= const ["name", "style", "ibu"]});

  @override

  Widget build(BuildContext context) {

    return DataTable(

      columns: columnNames.map( 

        (name) => DataColumn(

          label: Expanded(

            child: Text(name, style: TextStyle(fontStyle: FontStyle.italic))

          )

        )

    ).toList(),

      rows: jsonObjects.map( 

        (obj) => DataRow(

            cells: propertyNames.map(

              (propName) => DataCell(Text(obj[propName]))

            ).toList()

          )

        ).toList());

  }



}