import 'package:flutter/material.dart';

class Search extends SearchDelegate{

  String selectedResult;

  final List<String> listNames;
  Search(this.listNames);

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

  List<String> recentList = ["Text 1 ", "Text 2 "];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestion = [];
    query.isEmpty ? suggestion = recentList : suggestion.addAll(listNames.where((element) => element.contains(query)));

    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(
            suggestion[index]
          ),
        );
      },
    );
  }
  
}