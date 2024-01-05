import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cervejas',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cervejas'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Nome',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Estilo',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'IBU',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Imperial Stout')),
                  DataCell(Text('Stout')),
                  DataCell(Text('75')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Belgian Tripel')),
                  DataCell(Text('Belgian Ale')),
                  DataCell(Text('35')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Hefeweizen')),
                  DataCell(Text('Wheat Beer')),
                  DataCell(Text('15')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('American Amber Ale')),
                  DataCell(Text('Amber Ale')),
                  DataCell(Text('40')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Porter')),
                  DataCell(Text('Porter')),
                  DataCell(Text('50')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Pilsner Urquell')),
                  DataCell(Text('Pilsner')),
                  DataCell(Text('30')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Milk Stout')),
                  DataCell(Text('Stout')),
                  DataCell(Text('25')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Gose')),
                  DataCell(Text('Sour Ale')),
                  DataCell(Text('10')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Doppelbock')),
                  DataCell(Text('Bock')),
                  DataCell(Text('35')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Session IPA')),
                  DataCell(Text('IPA')),
                  DataCell(Text('40')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Red Ale')),
                  DataCell(Text('Amber Ale')),
                  DataCell(Text('28')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Barleywine')),
                  DataCell(Text('Barleywine')),
                  DataCell(Text('65')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Saison')),
                  DataCell(Text('Farmhouse Ale')),
                  DataCell(Text('20')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Witbier')),
                  DataCell(Text('Belgian Ale')),
                  DataCell(Text('12')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Pale Lager')),
                  DataCell(Text('Lager')),
                  DataCell(Text('18')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Scottish Ale')),
                  DataCell(Text('Scottish Ale')),
                  DataCell(Text('30')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
