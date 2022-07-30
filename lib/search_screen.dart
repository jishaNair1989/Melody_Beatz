import 'package:flutter/material.dart';
import 'package:musiq_player/new_box.dart';
import 'package:musiq_player/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'getSongs.dart';
import 'music_home.dart';

class SearchScreen extends StatelessWidget {
   SearchScreen({Key? key}) : super(key: key);
  ValueNotifier<List<SongModel>> temp = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          toolbarHeight: 80,
          // title: const Text('S E A R C H',style: TextStyle(color: Colors.black54),),
          centerTitle: true,
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back,color: Colors.black54,)),
          backgroundColor: Colors.grey[300],
          elevation: 0,
        ),
        body: ListView(
          children: [
            Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              style: TextStyle(height: 1),
              decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged: (String? value) {
                if (value != null && value.isNotEmpty) {
                  temp.value.clear();
                  for (SongModel item in MusicHomeScreen.song) {
                    if (item.title
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      temp.value.add(item);
                    }
                  }
                }
                temp.notifyListeners();
              },
            ),
          ),

          SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: temp,
                    builder: (BuildContext context, List<SongModel> songData,
                        Widget? child) {
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final data = songData[index];
                            return NewBox(

                              child: ListTile(
                                leading: QueryArtworkWidget(
                                    nullArtworkWidget:
                                    const Icon(Icons.music_note),
                                    artworkFit: BoxFit.cover,
                                    id: data.id,
                                    type: ArtworkType.AUDIO),
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    data.title,
                                    style: const TextStyle(color: Colors.black),

                                  ),
                                ),
                                onTap: () {
                                  final searchIndex = createSearchIndex(data);
                                  FocusScope.of(context).unfocus();
                                  GetSongs.player.setAudioSource(
                                      GetSongs.createSongList(MusicHomeScreen.song),
                                      initialIndex: searchIndex);
                                  GetSongs.player.play();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => SongPageScreen(
                                          playerSong: MusicHomeScreen.song)));
                                },
                              ),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return const Divider();
                          },
                          itemCount: temp.value.length);
                    }),
              ],
            ),
          ),
        ),]
      ),
    )
    );
  }
   int? createSearchIndex(SongModel data) {
     for (int i = 0; i < MusicHomeScreen.song.length; i++) {
       if (data.id == MusicHomeScreen.song[i].id) {
         return i;
       }
     }
     return null;
   }

  }
