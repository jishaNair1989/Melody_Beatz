import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:musiq_player/new_box.dart';
import 'package:musiq_player/playlistAddSongs.dart';
import 'package:musiq_player/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'db/functions/db_playlist.dart';
import 'db/model/music_player.dart';
import 'getSongs.dart';

class PlaylistData extends StatefulWidget {
  const PlaylistData(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final MusicPlayer playlist;
  final int folderindex;
  @override
  State<PlaylistData> createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<PlaylistData> {
  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    getAllPlaylist();

    return NewBox(
          child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/images/playlistLottie.json',width: 200,height: 200,
                      fit: BoxFit.cover,

                   ),
                    Text(widget.playlist.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.black26,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          style:
                          ElevatedButton.styleFrom(primary: Colors.black),

                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => SongListPage(
                                  playlist: widget.playlist,
                                )));
                          },
                          child: const Text('Add Songs',)),
                    ),
                    ValueListenableBuilder(
                      valueListenable:
                      Hive.box<MusicPlayer>('playlistDB').listenable(),
                      builder: (BuildContext context, Box<MusicPlayer> value,
                          Widget? child) {
                        playlistsong = listPlaylist(
                            value.values.toList()[widget.folderindex].songIds);

                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: NewBox(
                                  child: ListTile(
                                      onTap: () {
                                        List<SongModel> newlist = [...playlistsong];

                                        //GetSongs.player.stop();
                                        GetSongs.player.setAudioSource(
                                            GetSongs.createSongList(newlist),
                                            initialIndex: index);
                                        //  GetSongs.player.play();
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (ctx) => SongPageScreen(
                                              playerSong: playlistsong,

                                            )));
                                      },
                                      leading: QueryArtworkWidget(
                                        id: playlistsong[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: Image.asset(
                                          'assets/images/Melody.png',
                                        ),
                                        // errorBuilder: (context, excepion, gdb) {
                                        //   setState(() {});
                                        //   return Image.asset('');
                                        // },
                                      ),
                                      title: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          playlistsong[index].title,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      subtitle: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          playlistsong[index].artist!,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            widget.playlist.deleteData(playlistsong[index].id);
                                             // Navigator.of(context).pop();

                                          },
                                          icon:  Icon(
                                            Icons.delete,
                                            color: Colors.red[300],
                                          ))),
                                ),
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return const Divider();
                            },
                            itemCount: playlistsong.length);
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          plsongs.add(GetSongs.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
