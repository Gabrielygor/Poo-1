import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/data_service.dart';

class Selection {
  static const List<int> options = [3, 5, 15];
}

class CustomScroll extends ScrollBehavior {  //Classe para personalizar Scroll
  @override
  Widget buildViewportChrome(
    BuildContext context,
    AxisDirection axisDirection,
    Widget child,
  ) {
    return GlowingOverscrollIndicator(
      axisDirection: axisDirection,
      child: child,
      color: Colors.pink,
      showTrailing: false,
      showLeading: false,
    );
  }
}


//Class/Fabrica que monta o aplicativo
class MyApp extends StatelessWidget {
  final List<int> loadOptions = Selection.options;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Final de POO com Dart"),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => loadOptions
                  .map(
                    (num) => PopupMenuItem(
                      value: num,
                      child: Text("Carregar $num itens por vez"),
                    ),
                  )
                  .toList(),
              onSelected: (number) {
                dataService.numberOfItems = number;
              },
            ),
          ],
        ),
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
                    columnNames: value['columnNames'],
                    onSearchChanged: (query) {
                    },
                  ),
                );
              case TableStatus.error:
                return Text("Erro ao carregar. FUDEU");
            }
            return Text("...");
          },
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
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
        onTap: (index) {
          state.value = index;
          _itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
              label: "Computers", icon: Icon(Icons.computer_outlined)),
          BottomNavigationBarItem(
              label: "Vehicles", icon: Icon(Icons.fire_truck_outlined)),
          BottomNavigationBarItem(
              label: "foods", icon: Icon(Icons.fastfood_outlined))
        ]);
  }
}

class DataTableWidget extends HookWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;
  final Function(String) onSearchChanged; 

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const [],
      this.propertyNames = const [],
      required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final sortAscending = useState(true);
    final sortColumnIndex = useState(0);
    final searchQuery = useState('');

    List filteredObjects = jsonObjects.where((obj) {

      return propertyNames.any((propName) =>
          obj[propName].toLowerCase().contains(searchQuery.value.toLowerCase()));
    }).toList();

    return Center(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration( //Função de pesquisar 
              hintText: 'Search...',
            ),
            onChanged: (value) {
              searchQuery.value = value; 
              onSearchChanged(value); 
            },
          ),
          DataTable(
            sortAscending: sortAscending.value,
            sortColumnIndex: sortColumnIndex.value,
            columns: columnNames
                .map(
                  (name) => DataColumn(
                    onSort: (columnIndex, ascending) {
                      sortColumnIndex.value = columnIndex;
                      sortAscending.value = !sortAscending.value;
                      dataService.ordenarEstadoAtual(
                          propertyNames[columnIndex], sortAscending.value);
                    },
                    label: Expanded(
                      child: Text(
                        name,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                )
                .toList(),
            rows: filteredObjects
                .map(
                  (obj) => DataRow(
                    cells: propertyNames
                        .map(
                          (propName) => DataCell(
                            Text(obj[propName]),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}