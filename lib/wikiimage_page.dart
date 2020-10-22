import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wikiimage/banco/wikiimage_db.dart';

class WikiImagePage extends StatefulWidget {

  final WikiImage wikiImage;

  WikiImagePage({this.wikiImage});

  @override
  _WikiImagePageState createState() => _WikiImagePageState();
}

class _WikiImagePageState extends State<WikiImagePage> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  
  WikiImage _editedWikiImage;

  @override
  void initState() {
    super.initState();

    if(widget.wikiImage == null){
      _editedWikiImage = WikiImage();
    } else {
      _editedWikiImage = WikiImage.fromMap(widget.wikiImage.toMap());
      _nameController.text = _editedWikiImage.nome;
      _descriptionController.text = _editedWikiImage.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[200],
        title: Text(_editedWikiImage.nome ?? "Novo WikiImage"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_editedWikiImage.nome != null && _editedWikiImage.nome.isNotEmpty){
            Navigator.pop(context, _editedWikiImage);
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedWikiImage.img != null ?
                      FileImage(File(_editedWikiImage.img)) :
                        AssetImage("images/semimagem.jpg")
                  )
                ),
              ),
              onTap: (){
                ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                  if(file == null) return;
                  setState(() {
                    _editedWikiImage.img = file.path;
                  });
                });
              },
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedWikiImage.nome = text;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Descrição"),
              onChanged: (text){
                _userEdited = true;
                _editedWikiImage.description = text;
              },
            )
          ],
        ),
      ),
    ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}