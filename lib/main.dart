import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const request = 'https://economia.awesomeapi.com.br/all/USD-BRL,EUR-BRL';

void main() async{
  runApp(ConversorApp());
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class ConversorApp extends StatefulWidget {
  @override
  _ConversorAppState createState() => _ConversorAppState();
}

class _ConversorAppState extends State<ConversorApp> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar, euro;

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
    }else{
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    }
  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
    }else{
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
    }else{
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }
  }

  void _clearAll(){
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.amber,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.amber,
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.black,     
        appBar: AppBar(
          title: Text(
            '\$ Conversor \$',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                   child: Text(
                   'Carregando dados...',
                   style: TextStyle(
                    fontSize: 22,
                    color: Colors.amber,
                   ),
                  ),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      'Erro ao carregar dados.',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.amber,
                      ),
                    ),
                  );
                } else {
                  dolar = double.parse(snapshot.data['USD']['bid']);
                  euro = double.parse(snapshot.data['EUR']['bid']);

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 100, bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 150,
                          ),
                          Divider(),
                          criarTextField('Reais', 'R\$ ', realController, _realChanged),
                          Divider(),
                          criarTextField('Dólar', 'U\$ ', dolarController, _dolarChanged),
                          Divider(),
                          criarTextField('Euro', '£ ', euroController, _euroChanged),
                        ],
                      ),
                    ),
                  );
                }
            }
          }
        ),
      ),
    );
  }
}

TextField criarTextField(String texto, String prefixo, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: texto,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      prefixText: prefixo,                          
    ),
    style: TextStyle(
      color: Colors.amber,
    ),
    keyboardType: TextInputType.number,
    onChanged: f,
  );
}