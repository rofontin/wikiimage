import 'package:flutter/material.dart';
import 'package:wikiimage/banco/resultado_search.dart';
import 'package:wikiimage/banco/wikiimage_db.dart';

class Search extends SearchDelegate{

  String selectedResult;
  final List<WikiImage> wikiImages;
  Search(this.wikiImages);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestion = [];
    List<String> listNames = [];

    for (var item in wikiImages) {
      listNames.add(item.nome);
    }

    query.isEmpty ? suggestion = recentList : suggestion.addAll(listNames.where((element) => element.contains(query)));

    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(
            suggestion[index]
          ),
          onTap: (){
            selectedResult = suggestion[index];
            WikiImage wikiImage = WikiImage();
            
            for (var item in wikiImages) {
              if(selectedResult == item.nome){
                wikiImage = item;
              }
            }

            if(wikiImage != null){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=> ResultadoSearch(wikiImage: wikiImage,))
              );
            }

          },
        );
      },
    );
  }
  
}