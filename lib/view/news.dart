// ignore_for_file: prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trashbin/models/news_model.dart';
import 'package:trashbin/models/trash.dart';
import 'package:trashbin/widgets/news_card.dart';
import 'package:trashbin/widgets/news_list_tile.dart';

class NewsPage extends StatefulWidget {
  final List<Plant> favoritedPlants;
  const NewsPage({Key? key, required this.favoritedPlants}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            'News Page',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notification_add_outlined,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Breaking News",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // build the caroussel
                CarouselSlider.builder(
                    itemCount: NewsData.beakingNewsData.length,
                    itemBuilder: (context, index, id) =>
                        NewsCard(NewsData.beakingNewsData[index]),
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                    )),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  "Recent News",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                //Now card section from recent news
                Column(
                  children: NewsData.recentNewsData
                      .map((e) => NewsListTile(e))
                      .toList(),
                ),
              ],
            ),
          ),
        ));
  }
}
