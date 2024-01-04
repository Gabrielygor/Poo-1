import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(primarySwatch: Colors.pink),
    home: Scaffold(
      appBar: AppBar(title: Text("My app")),
      body: Center(
        child: Column(
          children: [
            Text("Apenas começando..."),
            Text(
              "No meio...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Renan Japones"),
            Text("Terminando..."),
            SizedBox(height: 20),
            Image.network(
              'https://avatars.githubusercontent.com/u/134844946?v=4', 
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
              },
              child: Text("Botão 1"),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
              },
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
              },
              child: Text("Botão 3"),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.thumb_up),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
    ),
  );
  runApp(app);
}
