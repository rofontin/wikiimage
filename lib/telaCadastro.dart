import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: Colors.deepOrange[200],
        centerTitle: true,
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
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage("images/image.png")
                  )
                ),
              ),
              onTap: (){
                ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                  if(file == null) return;
                  setState(() {
                  //  _editedCadastro.img = file.path;
                  });
                });
              },
            ),
            TextField(
              //controller: _nameController,
              decoration: InputDecoration(labelText: "Nome Imagem"),
              onChanged: (text){},
            ),
            TextField(
              //controller: _descriptionController,
              decoration: InputDecoration(labelText: "Descrição"),
              onChanged: (text){},
            )
          ],
        ),
      ),
    );
  }
}