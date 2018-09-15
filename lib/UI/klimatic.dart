import 'package:flutter/material.dart';
import '../Util/util.dart' as utils;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  Map dadosDoTempo;

  void getClima() async {
    dadosDoTempo = await getWeather(utils.defaultCity);
    //print(dadosDoTempo.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Klimatic',
          style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.blueGrey,
            onPressed: getClima,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Image.asset(
            'images/umbrella.png',
            width: 2490.0,
            height: 1200.0,
            fit: BoxFit.fill,
          )),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 11.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('cidade',
                      style: TextStyle(color:Colors.yellowAccent[200],fontSize:10.0),
                      textAlign: TextAlign.start,
                ),
                Text(
                  utils.defaultCity,
                  style: cityStyle(),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          Container(
              margin: EdgeInsets.only(top: 150.0),
              alignment: Alignment.center,
              //child: Text(atualizarTemperatura(utils.defaultCity)),
              child: Center(
                  child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 250.0),
                ),
                atualizarTemperatura(utils.defaultCity),
              ]))),
        ],
      ),
    );
  }

  Future<Map> getWeather(String city) async {
    String apiURL =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${utils.apiID}&units=metric';

    http.Response response = await http.get(apiURL);

    return json.decode(response.body);
  }

  Widget atualizarTemperatura(String myCity) {
    return FutureBuilder(
        future: getWeather(myCity),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if (content.isNotEmpty) {
              try {
                return Text(
                  content['main']['temp'].toString(),
                  style: weatherStyle(),
                );
              } catch (ex) {
                return Text(
                  'Não foi possível obter a temperatura. Verifique a cidade',
                  style: TextStyle(color: Colors.white),
                );
              }
            } else {
              return Text(
                'Não foi possível obter a temperatura. Servidor indisponível.',
                style: TextStyle(color: Colors.white),
              );
            }
          } else {
            return Text('Verificando a temperatura atual...');
          }
        });
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle weatherStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 49.9,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );
}
