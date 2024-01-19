import 'package:flutter/material.dart';

/* 

  Receita 02 OBS

  override sobrescreve uma classe herdada anteriormente.

  extends StatelessWidget, transorma a calsse em um Widget.

  Uma classe descreve os atributos e caracteristicas de um objeto

 */


void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(primarySwatch: Colors.pink),
    home: Scaffold(
      appBar: NewAppBar(),
      body: NewArticle(),
      bottomNavigationBar: NewNavBar(
        items: [
          NavBarItem(
            icon: Icon(Icons.apartment, color: Colors.blue),
            label: "Home",
          ),
          NavBarItem(
            icon: Icon(Icons.ac_unit, color: Colors.green),
            label: "Temperature",
          ),
          NavBarItem(
            icon: Icon(Icons.access_alarm, color: Colors.red),
            label: "Alarm",
          ),
          NavBarItem(
            icon: Icon(Icons.accessible, color: Color.fromARGB(255, 0, 0, 0)),
            label: "Cadeirante",
          ),
          NavBarItem(
            icon: Icon(Icons.drag_handle, color: Color.fromARGB(255, 255, 230, 0)),
            label: "grag",
          ),
        ],
      ),
    ),
  );

  runApp(app);
}

class NavBarItem {
  final Icon icon; //Final define que depois de incializar não pode ser alterado
  final String label;

  NavBarItem({required this.icon, required this.label});
}

class NewNavBar extends StatelessWidget {
  final List<NavBarItem> items;

  NewNavBar({this.items = const []});

  void touchedButton(int index) {
    print("Touched: $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: touchedButton,
      items: items
          .map((item) =>
              BottomNavigationBarItem(icon: item.icon, label: item.label))
          .toList(),
    );
  }
}

class NewArticle extends StatelessWidget { //Conteudo do Body
  NewArticle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(
            child: Text("La Fin Du Monde - Bock - 65 ibu"),
          ),
          Expanded(
            child: Text("Sapporo Premiume - Sour Ale - 54 ibu"),
          ),
          Expanded(
            child: Text("Duvel - Pilsner - 82 ibu"),
          )
        ],
      ),
    );
  }
}

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  NewAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Dicas"),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}