import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './views/video_cell.dart';

void main() => runApp(RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWordState();
  }
}

class RealWordState extends State<RealWorldApp> {
  var _isLoading = false;
  var videos;

  _fetchData() async {
    print("FETCHING DATA!");

    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);
    //print(response);

    if (response.statusCode == 200) {
      print(response.body);
      final map = json.decode(response.body);
      final videosJson = map["videos"];
      this.videos = videosJson;
      // videosJson.forEach((video){
      //   print(video["name"]);
      // });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text("REAL WORLD APP BAR"),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  print("reloading");
                  setState(() {
                    _isLoading = true;
                  });
                  _fetchData();
                },
              )
            ],
          ),
          body: new Center(
            child: _isLoading
                ? new CircularProgressIndicator()
                : new ListView.builder(
                    itemCount: this.videos != null ? this.videos.length : 0,
                    itemBuilder: (context, i) {
                      final video = this.videos[i];
                      return new VideoCell(video);
                    },
                  ),
          )),
    );
  }
}
