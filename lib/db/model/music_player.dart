import 'package:hive/hive.dart';
part 'music_player.g.dart';


@HiveType(typeId: 1)
class MusicPlayer extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songIds;

  MusicPlayer({
    required this.name,
    required this.songIds,
  });

  add(int id) async {
    songIds.add(id);
    save();
  }

  deleteData(int id) {
    songIds.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songIds.contains(id);
  }
}
