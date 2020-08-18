import 'dart:convert';
import 'package:Buscador_de_GIFs/Pages/gifpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchFieldController = TextEditingController();
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search == "") {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=9LI11uZ8WtkMlXOOJyFSTMWkjnvK8imU&limit=300&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=9LI11uZ8WtkMlXOOJyFSTMWkjnvK8imU&q=$_search&limit=20&offset=$_offset&rating=g&lang=pt");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          child: Image.asset("images/titleAppBar.gif"),
          onTap: () {
            setState(() {
              _search = "";
              _searchFieldController.clear();
            });
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchFieldController,
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _offset = 0;
                  _search = text;
                });
              },
            )),
        Expanded(
          child: FutureBuilder(
            future: _getGifs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ));
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _createGifTable(context, snapshot);
              }
            },
          ),
        )
      ]),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
            if (_search == null ||
              _search == "" ||
              index < snapshot.data["data"].length - 1) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]
                      ["url"],
                  height: 300.0,
                  fit: BoxFit.cover),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              onLongPress: () {
                Share.share(
                    snapshot.data["data"][index]["images"]["original"]["url"]);
              },
            );
          } else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0),
                    Text("Carregar mais GIFs",
                        style: TextStyle(color: Colors.white, fontSize: 22.0))
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        });
  }
}
