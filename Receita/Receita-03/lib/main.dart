import 'package:flutter/material.dart';


/* Receita 03

  OBS: Nao consegui o index nois botoes (nao necessario)
 */
void main() {
  MyApp app = MyApp();
  runApp(app);
}

// Definindo a classe principal do aplicativo, que é um StatelessWidget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Definindo o tema do aplicativo.
        theme: ThemeData(primarySwatch: Colors.amber),
        // Removendo o banner de depuração.
        debugShowCheckedModeBanner: false,
        // Definindo a tela inicial do aplicativo.
        home: Scaffold(
          // Definindo a barra superior do aplicativo.
          appBar: MyAppBar(),
          // Definindo o corpo principal do aplicativo.
          body: DataBodyWidget(objects: const [
            "La Fin Du Monde - Bock - 65 ibu",
            "Sapporo Premiume - Sour Ale - 54 ibu",
            "Duvel - Pilsner - 82 ibu"
          ]),
          // Definindo a barra de navegação inferior do aplicativo.
          bottomNavigationBar: NewNavBar(icons: const [
            Icons.home,
            Icons.search,
            Icons.accessibility
          ]),
        ));
  }
}

// Definindo a barra superior do aplicativo.
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Colors? selected; // Variável para armazenar a cor selecionada.

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Receita-POO-03"), // Título da barra superior.
      actions: [
        PopupMenuButton(
            onSelected: (value) {
            },
            itemBuilder: (context) => const [
                  // Itens do menu suspenso.
                  PopupMenuItem(
                    value: Colors.black,
                    child: Text("Black"),
                  ),
                  PopupMenuItem(
                    value: Colors.blue,
                    child: Text("blue"),
                  ),
                  PopupMenuItem(
                    value: Colors.pink,
                    child: Text("pink"),
                  ),
                ])
      ],
    );
  }
}

// Definindo a barra de navegação inferior do aplicativo.
class NewNavBar extends StatelessWidget {
  final List icons; // Lista de ícones para exibir na barra de navegação.

  NewNavBar({required this.icons});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: icons
            .map((data) =>
                BottomNavigationBarItem(icon: Icon(data), label: "Button"))
            .toList());
  }
}

// Widget para exibir dados no corpo principal do aplicativo.
class DataBodyWidget extends StatelessWidget {
  List<String> objects; // Lista de objetos a serem exibidos.

  DataBodyWidget({this.objects = const []});

  Expanded processarUmElemento(String obj) {
    return Expanded(
      child: Center(child: Text(obj)), // Centralizando o texto.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: objects
            .map((obj) => Expanded(
                  child: Center(child: Text(obj)), // Centralizando o texto.
                ))
            .toList());
  }
}