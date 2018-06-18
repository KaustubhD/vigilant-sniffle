import 'package:meta/meta.dart';

class DemoSong{
  final String songURL;
  final String albumArt;
  final String songTitle;
  final String artistName;

  DemoSong({
    @required this.songURL,
    @required this.albumArt,
    @required this.songTitle,
    @required this.artistName,
  });
}
class DemoPlaylist{
  final List<DemoSong> demopl;

  DemoPlaylist({
    @required this.demopl,
});
}

final playlist = new DemoPlaylist(demopl: [

  new DemoSong(
      songURL: 'https://raw.githubusercontent.com/kayd33/StockMusic/master/Songs/n8U6jgr1TDD6.128.mp3',
      albumArt: 'https://i4.sndcdn.com/artworks-000131749232-kuxqvn-t500x500.jpg',
      songTitle: 'Solitude',
      artistName: 'nymamo'
  ),
  new DemoSong(
    songURL: 'https://raw.githubusercontent.com/kayd33/stockMusic/master/Songs/VwJK7a5HVGzl.128.mp3',
    albumArt: 'https://i.scdn.co/image/967661595be2ffdd741e8e7c72cbd975dfc263b5',
    songTitle: 'In my remains',
    artistName: 'Linkin Park'
  ),


]);