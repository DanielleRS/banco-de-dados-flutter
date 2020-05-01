import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(
  MaterialApp(
    home: Home(),
  )
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );
    
    return bd;

    //print("aberto: " + bd.isOpen.toString());
  }
  
  _salvar() async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Zurick Gouveia",
      "idade": 18
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();

    //String sql = "SELECT * FROM usuarios WHERE id = 5";
    //String sql = "SELECT * FROM usuarios WHERE idade = 30 OR idade = 58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 20 AND 46";
    //String sql = "SELECT * FROM usuarios WHERE idade IN (20, 30)";
    //String filtro = "ari";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%'";
    //String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) DESC";
    String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY idade DESC LIMIT 3";
    List usuarios = await bd.rawQuery(sql);

    for(var usuario in usuarios){
      print(
        "item id: " + usuario['id'].toString() +
          " nome: " + usuario['nome'] +
          " idade: " + usuario['idade'].toString()
      );
    }

    //print("usuarios: " + usuarios.toString());
  }

  @override
  Widget build(BuildContext context) {
    //_recuperarBancoDados();
    //_salvar();
    _listarUsuarios();
    return Container();
  }
}



