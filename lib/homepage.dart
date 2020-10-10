import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wikiimage/banco/wikiimage_db.dart';
import 'package:wikiimage/wikiimage_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  WikiImageDB wikiImageDB = WikiImageDB();
  List<WikiImage> wikiImages = List();

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
        backgroundColor: Color(0xFFAE74),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: wikiImages.length,
        itemBuilder: (context, index){
          return _wikiImageCard(context, index);
        },
      ) 
    );
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
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: wikiImages[index].img != null ?
                      FileImage(File(wikiImages[index].img)): AssetImage("images/image.png")
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(wikiImages[index].nome ?? "",
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(wikiImages[index].description ?? "",
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context,
      builder: (context) => 
      BottomSheet(
        onClosing: (){},
        builder: (context) =>
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                    child: Text("Editar", 
                      style: TextStyle(color: Colors.red, fontSize: 20.0)),
                    onPressed: (){
                      Navigator.pop(context);
                      //_showikiImagePage(wikiImage: wikiImages[index]);
                    },
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                    child: Text("Excluir", 
                      style: TextStyle(color: Colors.red, fontSize: 20.0)),
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
          ),
      ),
    );
  }

  void _showContactPage({WikiImage wikiImage}) async {
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
}