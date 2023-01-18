import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
import '../components/neumorphic_container.dart';

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
              Expanded(
                  child: NeumorphicContainer(
                child: ListView.builder(
                    clipBehavior: Clip.antiAlias,
                    itemCount: favoritesController.myFavorites.length,
                    itemBuilder: (context, index) {
                      var currentMusic =
                          favoritesController.myFavoriteSongs[index];
                      return Card(
                        elevation: 5,
                        color: Colors.grey[300],
                        child: ListTile(
                          leading: currentMusic.coverImageUrl.length != 13
                              ? SizedBox(
                                  width: 80,
                                  height: 60,
                                  child:
                                      Image.memory(currentMusic.coverImageUrl))
                              : SizedBox(
                                  width: 80,
                                  height: 60,
                                  child: Image.asset(
                                      'assets/images/music_icon5.png')),
                          title: Text(
                            currentMusic.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            currentMusic.artist,
                            maxLines: 2,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Get.toNamed('songPlaying',
                                  arguments: currentMusic);
                            },
                            icon: const Icon(
                              Icons.play_circle_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
