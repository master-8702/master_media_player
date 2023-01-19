import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/song_card2.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
import '../components/neumorphic_container.dart';

// this class is going to build the Ui for the favorites screen that will display all the list of favorite musics
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesController favoritesController =
      Get.put(FavoritesController());

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: NeumorphicContainer(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  const Expanded(
                    child: Text(
                      "My Favorites",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GetBuilder<FavoritesController>(builder: (context) {
                return Expanded(
                    child: ListView.builder(
                        clipBehavior: Clip.antiAlias,
                        itemCount: favoritesController.myFavorites.length,
                        itemBuilder: (context, index) {
                          var currentMusic =
                              favoritesController.myFavoriteSongs[index];
                          return SongCard2(song: currentMusic);
                        }));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
