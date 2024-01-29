import 'package:flutter/material.dart';

/* Receita - 04

 */

var dataObjects = [
  {"name": "The Witcher 3: Wild Hunt", "genre": "RPG", "metacritic_score": "92"},
  {"name": "DOOM Eternal", "genre": "First-Person Shooter", "metacritic_score": "88"},
  {"name": "Divinity: Original Sin 2", "genre": "RPG", "metacritic_score": "93"},
  {"name": "Counter-Strike: Global Offensive", "genre": "First-Person Shooter", "metacritic_score": "83"},
  {"name": "Grand Theft Auto V", "genre": "Action-Adventure", "metacritic_score": "97"},
  {"name": "The Elder Scrolls V: Skyrim", "genre": "Action RPG", "metacritic_score": "94"},
  {"name": "Civilization VI", "genre": "Strategy", "metacritic_score": "88"},
  {"name": "Half-Life: Alyx", "genre": "VR, First-Person Shooter", "metacritic_score": "93"},
  {"name": "Red Dead Redemption 2", "genre": "Action-Adventure", "metacritic_score": "93"},
  {"name": "Portal 2", "genre": "Puzzle-Platformer", "metacritic_score": "95"},
  {"name": "Dark Souls III", "genre": "Action RPG", "metacritic_score": "89"},
  {"name": "Hollow Knight", "genre": "Metroidvania", "metacritic_score": "90"},
  {"name": "Stardew Valley", "genre": "Simulation, RPG", "metacritic_score": "89"},
  {"name": "The Legend of Zelda: Breath of the Wild", "genre": "Action-Adventure", "metacritic_score": "97"},
  {"name": "Death Stranding", "genre": "Action, Adventure", "metacritic_score": "82"},
  {"name": "Among Us", "genre": "Social Deduction", "metacritic_score": "82"}
];

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.pink),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Top Games"),
          ),
          body: MytileWidget(
              objects: dataObjects, propertyNames: ['genre', 'metacritic_score']),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class NewNavBar extends StatelessWidget {
  NewNavBar();

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: botaoFoiTocado, items: const [
      BottomNavigationBarItem(
        label: "Games",
        icon: Icon(Icons.coffee_outlined),
      ),
      BottomNavigationBarItem(
          label: "Steam", icon: Icon(Icons.local_drink_outlined)),
      BottomNavigationBarItem(label: "Pc Gamer", icon: Icon(Icons.flag_outlined))
    ]);
  }
}


class MytileWidget extends StatelessWidget {
  List objects;
  List propertyNames;

  MytileWidget({this.objects = const [], this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder( //Cria um lista e adiciona o scroll no APP
        itemCount: objects.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(objects[index]["name"]),
              subtitle: Text(
                  "${propertyNames[0]}: ${objects[index]["genre"]}, metacritic_score: ${objects[index]["metacritic_score"]}"),
            ),
          );
        });
  }
}



//Função utilizada na aula (retirada pois criei a função MytileWidget)
//Deixei o codigo abaixo por motivo de estudo posteriormente ;)

// class DataBodyWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> objects;
//   final List<String> columnNames;
//   final List<String> propertyNames;

//   DataBodyWidget({required this.objects,required this.columnNames,
//   required this.propertyNames});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: DataTable(
//             columns: columnNames
//                 .map((name) => DataColumn(
//                     label: Flexible(
//                         child: Text(name,
//                           style:
//                             const TextStyle(fontStyle: FontStyle.italic))))).toList(),
                            
//             rows: objects
//                 .map((obj) => DataRow(
//                     cells: propertyNames
//                         .map((propName) => DataCell(Text(obj[propName])))
//                         .toList()))
//                 .toList()),
//       ),
//     );
//   }
// }