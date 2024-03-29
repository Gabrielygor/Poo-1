import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/ordenador.dart';
import '../util/filtrador.dart';

var values = [3, 7, 15];

enum TableStatus { idle, loading, ready, error }

/* 

URI:
https://random-data-api.com/api/vehicle/random_vehicle
https://random-data-api.com/api/computer/random_computer
https://random-data-api.com/api/food/random_food

*/

enum ItemType {  //Informações para montar a URI de cada API
  computer,
  food,
  vehicle,
  none;

  String get asString => '$name';

  List<String> get columns => this == computer
      ? ["Platform", "Type", "Operational system" , "stack"]
      : this == vehicle
          ? ["Model", "Color", "Streaming" , "Type of fuel"]
          : this == food
              ? ["Dish", "Ingredients", "Measurement"]
              : [];

  List<String> get properties => this == computer
      ? ["platform", "type", "os" , "stack"]
      : this == vehicle
          ? ["make_and_model", "color", "transmission" , "fuel_type"]
          : this == food
              ? ["dish", "ingredient", "measurement"]
              : [];
}

class DataService {
  static final values = [3, 7, 15];

  static int get MAX_N_ITEMS => values[2];
  static int get MIN_N_ITEMS => values[0];
  static int get DEFAULT_N_ITEMS => values[1];

  int _numberOfItems = DEFAULT_N_ITEMS;

  set numberOfItems(n) {
    _numberOfItems = n < 0
        ? MIN_N_ITEMS
        : n > MAX_N_ITEMS
            ? MAX_N_ITEMS
            : n;
  }

  int get numberOfItems {
    return _numberOfItems;
  }

  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier<Map<String, dynamic>>({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none
  });

  //Carrega os parametros da API
  void carregar(index) {
    final params = [ItemType.computer, ItemType.vehicle, ItemType.food];
    carregarPorTipo(params[index]);
  }

  //Função pra ordenar a lista em ordem ALFA
  void ordenarEstadoAtual(String propriedade, [bool cresc = true]) {
    List objetos = tableStateNotifier.value['dataObjects'] ?? [];
    if (objetos.isEmpty) return;
    Ordenador ord = Ordenador();
    var objetosOrdenados = [];
    bool crescente = cresc;
    bool precisaTrocar(atual, proximo) {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][propriedade]
              .compareTo(ordemCorreta[1][propriedade]) >
          0; 
    }

    objetosOrdenados = ord.ssOrdenar(objetos, precisaTrocar);
    emitirEstadoOrdenado(objetosOrdenados, propriedade);
  }

  void filtrarEstadoAtual(final String filtro) {
    List objetos = tableStateNotifier.value['previousObjects'] ?? [];
    if (objetos == []) return;
    List propriedades = tableStateNotifier.value['propertyNames'];
    Filtrador fil = Filtrador();
    DecididorFiltro d = DecididorFiltroJSON(propriedades);
    var objetosFiltrados = fil.filtrar(objetos, filtro, d.dentroDoFiltro);
    emitirEstadoFiltrado(objetos, objetosFiltrados, filtro);
  }

  void emitirEstadoOrdenado(
    List objetosOrdenados,
    String propriedade,
  ) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['dataObjects'] = objetosOrdenados;
    tableStateNotifier.value = estado;
  }

  Uri montarUri(ItemType type) {  //Random data api 
    return Uri(  //Cria a URI para usar a API
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/${type.asString}/random_${type.asString}',
        queryParameters: {'size': '$_numberOfItems'});
  }

  Future<List<dynamic>> acessarApi(Uri uri) async {
    var jsonString = await http.read(uri);
    var json = jsonDecode(jsonString);
    json = [...tableStateNotifier.value['dataObjects'], ...json];
    return json;
  }

  void emitirEstadoFiltrado(  
      List objetosOriginais, List objetosFiltrados, String filtro) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['previousObjects'] = objetosOriginais;
    estado['dataObjects'] = objetosFiltrados;
    estado['filterCriteria'] = filtro;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoCarregando(ItemType type) {
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'itemType': type
    };
  }

  void emitirEstadoPronto(ItemType type, var json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'propertyNames': type.properties,
      'columnNames': type.columns
    };
  }

  bool temRequisicaoEmCurso() =>
      tableStateNotifier.value['status'] == TableStatus.loading;
  bool mudouTipoDeItemRequisitado(ItemType type) =>
      tableStateNotifier.value['itemType'] != type;

  void carregarPorTipo(ItemType type) async {
    //ignorar solicitação se uma requisição já estiver em curso
    if (temRequisicaoEmCurso()) {
      return;
    }
    if (mudouTipoDeItemRequisitado(type)) {
      emitirEstadoCarregando(type);
    }

    var uri = montarUri(type);
    var json = await acessarApi(uri); //, type);

    emitirEstadoPronto(type, json);
  }
}

final dataService = DataService();

class DecididorJson implements Decididor {
  final String prop;
  final bool crescente;

  DecididorJson(this.prop, [this.crescente = true]);
  @override
  bool precisaTrocarAtualPeloProximo(
      dynamic atual, dynamic proximo, bool crescente) {
    try {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][prop].compareTo(ordemCorreta[1][prop]) > 0;
    } catch (error) {
      return false;
    }
  }
}

class DecididorFiltroJSON extends DecididorFiltro {
  final List propriedades;

  DecididorFiltroJSON(this.propriedades);

  @override
  bool dentroDoFiltro(objeto, filtro) {
    bool achouAoMenosUm = false;
    for (int i = 0; i < propriedades.length - 1; i++) {
      achouAoMenosUm = objeto[propriedades[i]].contains(filtro) ? true : false;
      if (achouAoMenosUm) break;
    }
    return achouAoMenosUm;
  }
}