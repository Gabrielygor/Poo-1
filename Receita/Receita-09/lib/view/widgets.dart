import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/data_service.dart';

class Selection {
  static const List<int> selection = [3, 5, 7];
}

class MyApp extends StatelessWidget {
  final List<int> load = Selection.selection;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text("Recipe 09 "), actions: [
            PopupMenuButton( //Menu de 3 pontinhos
              itemBuilder: (_) => load
                  .map((num) => PopupMenuItem(
                        value: num,
                        child: Text("Carregar $num itens por vez"),
                      ))
                  .toList(),
              onSelected: (number) {
                dataService.numberOfItems = number;
              },
            )
          ]),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                switch (value['status']) {
                  case TableStatus.idle:
                    return Center(child: Text("1.Toque em algum botão abaixo"));
                  case TableStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case TableStatus.ready:
                    return SingleChildScrollView(
                        child: DataTableWidget(
                            jsonObjects: value['dataObjects'],
                            propertyNames: value['propertyNames'],
                            columnNames: value['columnNames']));
                  case TableStatus.error:
                    return Text("Erro ao carregar. FUDEU");
                }
                return Text("...");
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  final Function(int) itemSelectedCallback;

  NewNavBar({required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        selectedItemColor: Colors.pink,  //Cor do botoes
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
              label: "Nations", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget({
    this.jsonObjects = const [],
    this.columnNames = const [],
    this.propertyNames = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, //Scroll horizontal
      child: DataTable(
        columns: columnNames
            .map(
              (name) => DataColumn(
                label: Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            )
            .toList(),
        rows: jsonObjects
            .map(
              (obj) => DataRow(
                cells: propertyNames
                    .map(
                      (propName) => DataCell(Text(obj[propName])),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}