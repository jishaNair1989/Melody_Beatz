// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq_player/db/functions/db_fav.dart';
import 'package:musiq_player/music_home.dart';
import 'package:musiq_player/new_box.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'fav_butn.dart';
import 'getSongs.dart';

class SongPageScreen extends StatefulWidget {
  const SongPageScreen({Key? key, required this.playerSong}) : super(key: key);
  final List<SongModel> playerSong;

  @override
  State<SongPageScreen> createState() => _SongPageScreenState();
}

class _SongPageScreenState extends State<SongPageScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = true;
  bool _isshuffle = false;
  int currentIndex = 0;

  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        GetSongs.currentIndes = index;
      }
    });

    super.initState();
    sliderFun();
  }

  void sliderFun() {
    GetSongs.player.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    GetSongs.player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                //menu button and back button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: NewBox(
                          child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FavoriteDB.favoriteSongs.notifyListeners();
                        },
                        icon: const Icon(Icons.arrow_back),
                      )),
                    ),
                    // const Text('P L A L I S T'),
                    // const SizedBox(
                    //   height: 55,
                    //   width: 55,
                    //   child: NewBox(
                    //     child: Icon(Icons.menu),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // cover art,artist name,song name
                NewBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: QueryArtworkWidget(
                          keepOldArtwork: true,
                          id: widget.playerSong[GetSongs.currentIndes].id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          nullArtworkWidget:
                              Image.asset('assets/images/Melody.png',height: 200,width: 300,fit: BoxFit.cover,),
                          artworkHeight: 200,
                          artworkWidth: 300,
                          quality: 100,
                          artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                          artworkFit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.playerSong[GetSongs.currentIndes]
                                .displayNameWOExt,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              widget.playerSong[GetSongs.currentIndes].artist
                                          .toString() ==
                                      "<Unknown>"
                                  ? "<Unknown Artist?"
                                  : widget
                                      .playerSong[GetSongs.currentIndes].artist
                                      .toString(),
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          FavoriteBut(song: MusicHomeScreen.song[currentIndex]),
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.favorite,
                          //     color: Colors.red,
                          //     size: 32,
                          //   ),
                          //   onPressed: () {},
                          // )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                //start time,shuffle button,repeat button,end time

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_position.toString().split(".")[0]),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.all(15),
                          primary: Colors.transparent,
                          onPrimary: Colors.black),
                      onPressed: () {

                          _isshuffle == false
                              ? GetSongs.player.setShuffleModeEnabled(true)
                              : GetSongs.player.setShuffleModeEnabled(false);

                            const ScaffoldMessenger(
                            child: SnackBar(content: Text('Shuffle Enabled')));
                      },
                      child: StreamBuilder<bool>(
                          stream: GetSongs.player.shuffleModeEnabledStream,
                          builder: (context, AsyncSnapshot snapshot) {
                            _isshuffle = snapshot.data;
                            if (_isshuffle) {
                              return const Icon(
                                Icons.shuffle,
                                color: Colors.white,
                                size: 25,
                              );
                            } else {
                              return const Icon(
                                Icons.shuffle,
                                size: 25,
                                color: Colors.black,
                              );
                            }
                          }),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.transparent,
                            onPrimary: Colors.black),
                        onPressed: () {
                          GetSongs.player.loopMode == LoopMode.one
                              ? GetSongs.player.setLoopMode(LoopMode.all)
                              : GetSongs.player.setLoopMode(LoopMode.one);
                          const ScaffoldMessenger(
                              child: SnackBar(content: Text('Repeat changed')));
                        },
                        child: StreamBuilder<LoopMode>(
                          stream: GetSongs.player.loopModeStream,
                          builder: (context, snapshot) {
                            final loopMode = snapshot.data;
                            if (LoopMode.one == loopMode) {
                              return const Icon(
                                Icons.repeat_one,
                                color: Colors.white,
                                size: 25,
                              );
                            } else {
                              return const Icon(
                                Icons.repeat,
                                size: 30,
                              );
                            }
                          },
                        )),
                    Text(_duration.toString().split(".")[0])
                  ],
                ),

                NewBox(
                    child: Slider(
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            changeToSeconds(value.toInt());
                            value = value;
                          });
                        })),
                const SizedBox(
                  height: 20,
                ),

                //previous song, pause play, skip next song
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: NewBox(
                          child: IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                if (GetSongs.player.hasPrevious) {
                                  GetSongs.player.seekToPrevious();
                                  GetSongs.player.play();
                                } else {
                                  GetSongs.player.play();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: NewBox(
                              child: IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 32,
                                  color: Colors.cyan[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_isPlaying) {
                                      GetSongs.player.pause();
                                    } else {
                                      GetSongs.player.play();
                                    }
                                    _isPlaying = !_isPlaying;
                                  });
                                },
                              ),
                            ),
                          )),
                      Expanded(
                        child: NewBox(
                          child: IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(
                                () async {
                                  if (GetSongs.player.hasNext) {
                                    await GetSongs.player.seekToNext();
                                    await GetSongs.player.play();
                                  } else {
                                    await GetSongs.player.play();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetSongs.player.seek(duration);
  }
}
