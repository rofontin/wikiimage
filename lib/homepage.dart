import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wikiimage/banco/search_wikiimage.dart';
import 'package:wikiimage/banco/wikiimage_db.dart';
import 'package:wikiimage/wikiimage_page.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  WikiImageDB wikiImageDB = WikiImageDB();
  List<WikiImage> wikiImages = List();
  List<String> listNames = List();

  @override
  void initState() {
    super.initState();

    _getAllWikiImage();
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WikiImage"),
          backgroundColor: Colors.deepOrange[200],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
    
              for (var item in wikiImages) {
                    listNames.add(item.nome);
                  }

                showSearch(context: context, delegate: Search(listNames));
              },

            ),
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderza,
                ),
              ],
              onSelected: _orderList,
            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showikiImagePage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange[200],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: wikiImages.length,
          itemBuilder: (context, index) {
            return _wikiImageCard(context, index);
          },
        ));
  }

  void _getAllWikiImage(){
    wikiImageDB.getAllWikiImage().then((list){
      setState(() {
        wikiImages = list;
      });
    });
  }

  Widget _wikiImageCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                    child: Container(
                      width: 360.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: wikiImages[index].img != null ?
                            FileImage(File(wikiImages[index].img)): AssetImage("images/semimagem.jpg"),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(wikiImages[index].nome ?? "",
                              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                            Text(wikiImages[index].description ?? "",
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                    )
                  ],
                ),
              ],
            ),
          )
        ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(context: context, 
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                    child: Text("Editar", 
                      style: TextStyle(color: Colors.deepOrange[200], fontSize: 20.0)),
                    onPressed: (){
                      Navigator.pop(context);
                      _showikiImagePage(wikiImage: wikiImages[index]);
                    },
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                    child: Text("Excluir", 
                      style: TextStyle(color: Colors.deepOrange[200], fontSize: 20.0)),
                    onPressed: (){
                      wikiImageDB.deleteWikiImage(wikiImages[index].idWikiImage);
                      setState(() {
                        wikiImages.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  ),
                ],
              ),
            );
          },
        );
      });
  }

  void _showikiImagePage({WikiImage wikiImage}) async {
   final recWikiImage = await Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> WikiImagePage(wikiImage: wikiImage,))
    );

    if(recWikiImage != null){
      if(wikiImage != null){
        await wikiImageDB.updateWikiImage(recWikiImage);
      } else {
        await wikiImageDB.saveWikiImage(recWikiImage); 
      }
      _getAllWikiImage();
    }
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        wikiImages.sort((a,b){
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;

      case OrderOptions.orderza:
        wikiImages.sort((a,b){
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }
}