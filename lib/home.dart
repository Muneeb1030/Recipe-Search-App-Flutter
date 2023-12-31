import 'dart:convert';

import 'API Keys/APIKey.dart';
import 'package:connectivity/connectivity.dart';
import 'package:foodrecipe/Models/Recipe.dart';
import 'package:foodrecipe/RecipeWeb.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isloading = true;
  List<RecipeModel> _recipe = <RecipeModel>[];
  TextEditingController _searchController = new TextEditingController();

  Future<bool> CheckConnectivity() async {
    var conectivityResult = await (Connectivity().checkConnectivity());
    if (conectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=$appID&app_key=$appKey";
    Response response = await get(Uri.parse(url));
    Map map = jsonDecode(response.body);

    map["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      _recipe.add(recipeModel);
      setState(() {
        _isloading = false;
      });
    });

    _recipe.forEach((element) {
      print(element.applabel);
    });
  }

  @override
  void initState() {
    super.initState();
    CheckConnectivity().then((_isConnected) {
      if (_isConnected) {
        getRecipe("Pizza");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   child: AppBar(
      //     backgroundColor: Colors.blue[500],
      //   ),
      //   preferredSize: Size.fromHeight(0),
      // ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade300, Colors.blue.shade800],
                ),
              ),
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if ((_searchController.text)
                                      .replaceAll(" ", "") ==
                                  "") {
                                print("Nothing Found");
                              } else {
                                setState(() {
                                  _isloading = true;
                                  _recipe = [];
                                });
                                getRecipe(_searchController.text);
                              }
                            },
                            child: Container(
                              child: Icon(
                                Icons.search,
                                size: 35,
                                color: Colors.blue.shade300,
                              ),
                              margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                                cursorColor: Colors.blue.shade300,
                                controller: _searchController,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue.shade500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Let's Cook Something",
                                  hintStyle:
                                      TextStyle(color: Colors.blue.shade500),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: ((value) => {
                                      if (value.replaceAll(" ", "") != "")
                                        {
                                          setState(() {
                                            _isloading = true;
                                            _recipe = [];
                                          }),
                                          getRecipe(value)
                                        }
                                    })),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "WHAT DO YOU WANT TO COOK TODAY?",
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Text(
                          "Let's Cook Something New!",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      margin: EdgeInsets.only(top: 15),
                      child: _isloading
                          ? Container(
                              alignment: Alignment.center,
                              child: SpinKitSpinningLines(
                                color: Colors.white,
                                size: 120.0,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _recipe.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RecipeWeb(
                                                _recipe[index].appurl)))
                                  },
                                  child: Card(
                                    shape: BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            _recipe[index].appimgUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              _recipe[index].applabel,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20)),
                                                color: Colors.black38),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  _recipe[index]
                                                      .appcalories
                                                      .toString()
                                                      .substring(0, 5),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
