import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/colors.dart';
import 'package:music_player/music.dart';

class PreviousButtonWidget extends StatelessWidget {
  const PreviousButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child){
        return new IconButton(
          splashColor: LightPurple,
          highlightColor: LightPurple,
          icon: new Icon(Icons.skip_previous),
          color: Colors.white,
          onPressed: playlist.previous,
        );
      },
    );
  }
}

class BottomHalfWidget extends StatelessWidget {
  const BottomHalfWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        child: new Material(
          color: Purple,

          child: new Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
              child: new Column(
                children: <Widget>[
                  new AudioPlaylistComponent(
                    playlistBuilder: (BuildContext context, Playlist pl, Widget child){
                      String songTitle = playlist.demopl[pl.activeIndex].songTitle;
                      String artistName = playlist.demopl[pl.activeIndex].artistName;
                      return new RichText(
                        text: new TextSpan(
                            text: '',
                            children: [
                              new TextSpan(
                                  text: songTitle.toUpperCase() + '\n',
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4.0,
                                      height: 1.9
                                  )
                              ),

                              new TextSpan(
                                  text: artistName.toUpperCase(),
                                  style: new TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.5,
                                      height: 1.0
                                  )
                              ),
                            ]
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),

                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(child: new Container()),

                        new PreviousButtonWidget(),

                        new Expanded(child: new Container()),


                        new PlayButtonWidget(),

                        new Expanded(child: new Container()),

                        new NextButtonWidget(),


                        new Expanded(child: new Container()),
                      ],
                    ),
                  )

                ],
              )
          ),
        )
    );
  }
}

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child){

        IconData icon = Icons.music_note;
        Color butColor = LightPurple;
        Function onPress;

        if(player.state == AudioPlayerState.paused){
          icon = Icons.play_arrow;
          onPress = player.play;
          butColor = Colors.white;
        }
        else if(player.state == AudioPlayerState.completed || player.state == AudioPlayerState.playing){
          icon = Icons.pause;
          onPress = player.pause;
          butColor = Colors.white;
        }

        return new RawMaterialButton(
          shape: new CircleBorder(),
          fillColor: butColor,
          elevation: 10.0,
          highlightElevation: 5.0,
          splashColor: PurpleAlphaLight,
          highlightColor: PurpleAlphaLight,
          onPressed: onPress,
          child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Icon(icon, color: Purple, size: 25.0),
          ),
        );
      },
    );
  }
}

class NextButtonWidget extends StatelessWidget {
  const NextButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child){
        return new IconButton(
          splashColor: LightPurple,
          highlightColor: LightPurple,
          icon: new Icon(Icons.skip_next),
          color: Colors.white,
          onPressed: playlist.next,
        );
      },
    );
  }
}


class CircleClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}