import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/*  Receita 5

alt arquivo pubspec.yaml = arquivo que tem as dependecias
do Flutter


 */


var dataObjects = [];

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("tap on MyApp");
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Import hooks"),
          ),
          body: DataTableWidget(jsonObjects: dataObjects),
          bottomNavigationBar: NewNavBar2(),
        ));
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;

  DataTableWidget({this.jsonObjects = const []});

  @override
  Widget build(BuildContext context) {
    print("tap on DataTableWidget");
    var columnNames = ["xxxx", "xxxxxx", "xxx"],
        propertyNames = ["xxxx", "xxxxxx", "xxx"];

    return DataTable(
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
            .toList());
  }
}

class NewNavBar2 extends StatefulWidget {
  @override
  _NewNavBar2State createState() => _NewNavBar2State();
}

class _NewNavBar2State extends State<NewNavBar2> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    print("tap on NewNavBar2");
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          label: "Coofe",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Search",
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}



// Classe desenvolvida na aula 
// presente aqui para estudo/duvidas posteriores

class NewNavBar extends HookWidget {
  NewNavBar();

  @override
  Widget build(BuildContext context) {
    print("in build of NewNavBar");
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Coofe",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: "Search'", icon: Icon(Icons.search))
        ]);
  }
}
