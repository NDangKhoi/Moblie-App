import 'package:flutter/material.dart';

class SearchDate extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton( icon: Icon(Icons.close),
      onPressed: (){
        query = "";
      },)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search date'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search date'),
    );
  }

}