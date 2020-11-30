import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wikiimage/banco/wikiimage_db.dart';

class ResultadoSearch extends StatefulWidget {

  final WikiImage wikiImage;

  ResultadoSearch({this.wikiImage});

  @override
  _ResultadoSearchState createState() => _ResultadoSearchState();
}

class _ResultadoSearchState extends State<ResultadoSearch> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: widget.wikiImage.img != null ?
            FileImage(File(widget.wikiImage.img)) :
              AssetImage("images/semimagem.jpg")
        )
      ),
    );
  }
}