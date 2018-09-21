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
  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
      return ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      //print(results['enter'].toString());
      _cityEntered = results['enter'];
    }
  }

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
            color: Colors.blueGrey,
            icon: Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            },
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
                Text(
                  'cidade',
                  style: TextStyle(
                      color: Colors.yellowAccent[200], fontSize: 10.0),
                  textAlign: TextAlign.start,
                ),
                Text(
                  //'$_cityEntered',
                  '${_cityEntered == null ? utils.defaultCity : _cityEntered}',
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
                atualizarTemperatura(_cityEntered),
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
        future: getWeather(myCity == null ? utils.defaultCity : myCity),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if (content.isNotEmpty) {
              try {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        content['main']['temp'].toString(),
                        style: weatherStyle(),
                      ),
                      Text(
                       "Umidade: ${content['main']['humidity'].toString()}" ,
                       style: dadosExtras(),
                      ),
                      Text(
                        "Min.: ${content['main']['temp_min'].toString()}" ,
                        style: dadosExtras(),
                      ),
                      Text(
                        "Max.: ${content['main']['temp_max'].toString()}" ,
                        style: dadosExtras(),
                      ),
                    ],
                  ),
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

class ChangeCity extends StatelessWidget {
  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text('Change City'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/white_snow.png',
                width: 490.0, height: 1200.0, fit: BoxFit.fill),
          ),
          ListView(children: <Widget>[
            ListTile(
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Informe a cidade',
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              ),
            ),
            ListTile(
              title: FlatButton(
                child: Text('Get Weather'),
                color: Colors.redAccent,
                textColor: Colors.white70,
                onPressed: () {
                  Navigator.pop(context, {
                    'enter': _cityFieldController.text,
                  });
                },
              ),
            ),
          ])
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle dadosExtras() {
  return TextStyle(
    color: Colors.white70,
    fontSize: 17.0,
    fontStyle: FontStyle.normal,
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
