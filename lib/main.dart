import 'package:flutter/material.dart';
import './helper/data.dart';
import './helper/news.dart';
import './model/category_model.dart';
import './model/article_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './article_view.dart';
import './category_view.dart';


void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 List<CategoryModel> category= List<CategoryModel>();
   List<ArticleModel> articles = List<ArticleModel>();
 bool loading=true;
 String _value='in';

@override
void initState(){
  super.initState();
category=getCategories();
getNews();


}


  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.share,
              ))
        ],
      flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only( bottomRight:Radius.circular(20), bottomLeft:Radius.circular(20) ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              Colors.red,
              Colors.blue
            ])          
         ),        
     ),      
     backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body:loading?Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
       padding: EdgeInsets.symmetric(horizontal:20),
       child: Column(
         children: [
           Container(
              margin: EdgeInsets.only(top: 16),
height: 70,
child: ListView.builder(
  itemCount: category.length,
  scrollDirection: Axis.horizontal,
itemBuilder: (context,index){
  return CategoryTile(
    imageUrl:category[index].imageUrl,
    categoryName:category[index].categoryName
  );

}

),

           ),
           Container(
                    padding: EdgeInsets.only(top: 16),
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return BlogTile(
                          imageUrl: articles[index].urlToImage,
                          title: articles[index].title,
                          desc: articles[index].description,
                          url: articles[index].url,
                        );
                      },
                    ),
                  )
         ],
       ),
      )
        
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryNews(
              category: categoryName.toLowerCase(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 60,
                  fit: BoxFit.cover),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile({
    @required this.imageUrl,
    @required this.title,
    @required this.desc,
    @required this.url,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(
              blogUrl: url,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageUrl),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}