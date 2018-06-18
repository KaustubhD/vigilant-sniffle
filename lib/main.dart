import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'package:music_player/BottomHalf.dart';
import 'package:music_player/colors.dart';
import 'package:music_player/music.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new AudioPlaylist(
      playlist: playlist.demopl.map((DemoSong song){
        return song.songURL;
      }).toList(growable: false),
//      audioUrl: playlist.demopl[0].songURL,
      playbackState: PlaybackState.paused,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            color: Colors.grey,
            onPressed: (){},
          ),

          title: new Text(''),

          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.menu),
              color: Colors.grey,
              onPressed: (){},
            ),
          ],

        ),
        body: new Column(
          children: <Widget>[
            //Album art and seek
            new Expanded(
              child: new AudioPlaylistComponent(
                playlistBuilder: (BuildContext context, Playlist pl, Widget child){
                  String albumArt = playlist.demopl[pl.activeIndex].albumArt;
                  return new AudioRadialSeekBar(
                      albumArtURL: albumArt,
                  );
                }
              ),
            ),

            //Visualiser
            new Container(
              width: double.infinity,
              height: 125.0
            ),

            //Artist, album, control button
            new BottomHalfWidget(),


          ],
        ),


      ),
    );
  }
}

class AudioRadialSeekBar extends StatefulWidget {
  final String albumArtURL;

  AudioRadialSeekBar({
    this.albumArtURL,
  });

  @override
  AudioRadialSeekBarState createState() {
    return new AudioRadialSeekBarState();
  }
}

class AudioRadialSeekBarState extends State<AudioRadialSeekBar> {

  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking,
      ],
                playerBuilder: (BuildContext context, AudioPlayer player, Widget child){
                  double playbackProgress = 0.0;
                  if(player.audioLength != null || player.position != null){
                    playbackProgress = player.position.inMilliseconds / player.audioLength.inMilliseconds;
                  }

                  _seekPercent = player.isSeeking ? _seekPercent : null;

                  return new RadialSeekBar(
                    progress: playbackProgress,
                    seekPercent: _seekPercent,
                    seekIsRequested: (double seekPercent){
                      setState(() {
                        _seekPercent = seekPercent;

                        final seekInMilliSeconds = (_seekPercent * player.audioLength.inMilliseconds).round();
                        player.seek(new Duration(milliseconds: seekInMilliSeconds));
                      });
                    },
                    child: new Container(
                      color: LightPurple,
                      child: new Image.network(
                        widget.albumArtURL,
                        fit: BoxFit.cover,
                      ),
                    )
                  );
                },
    );
  }
}

class RadialSeekBar extends StatefulWidget {
//  const RadialSeekBar({
//    Key key,
//    @required this._currentDragPercent,
//    @required this._seekPercent,
//  }) : super(key: key);

  final double seekPercent;
  final double progress;
  final Function(double) seekIsRequested;
  final Widget child;

  RadialSeekBar({
    this.progress = 0.0,
    this.seekPercent = 0.0,
    this.seekIsRequested,
    this.child,
  });



  @override
  RadialSeekBarState createState() {
    return new RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {

  double _progress = 0.0;
  PolarCoord _startCo;
  double _startDragPercent;
  double _currentDragPercent;


  void _startDrag(PolarCoord co){
    _startCo = co;
    _startDragPercent = _progress;

  }

  void _updateDrag(PolarCoord co){
    final _dragAngle = co.angle - _startCo.angle;
    final _dragPercent = (_dragAngle / (2 * pi));

    setState(() => _currentDragPercent = (_dragPercent + _startDragPercent) % 1.0);

  }

  void _endDrag(){
    if(widget.seekIsRequested != null){
      widget.seekIsRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent = null;
      _startCo = null;
      _startDragPercent = 0.0;
    });

  }



  @override
  Widget build(BuildContext context) {

    double thumbPosition = _progress;
    if(_currentDragPercent != null){
      thumbPosition = _currentDragPercent;
    }
    else if(widget.seekPercent != null){
      thumbPosition = widget.seekPercent;
    }

    return new RadialDragGestureDetector(
      onRadialDragStart: _startDrag,
      onRadialDragUpdate: _updateDrag,
      onRadialDragEnd: _endDrag,
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: new Center(
          child: new Container(
            width: 130.0,
            height: 130.0,
            child: new RadialProgressBar(
              progressInPercent: _progress,
              thumbInPercent: thumbPosition,
              innerPadding: new EdgeInsets.all(8.0),
              child: new ClipOval(
                clipper: new CircleClipper(),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
      _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _progress = widget.progress;
  }


}




class RadialProgressBar extends StatefulWidget {

  final double trackLineWidth;
  final Color trackLineColor;
  final double progressLineWidth;
  final Color progressLineColor;
  final double progressInPercent;
  final double thumbRadius;
  final Color thumbColor;
  final double thumbInPercent;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialProgressBar({
    this.trackLineWidth = 1.0,
    this.trackLineColor = const Color(0xffababab),
    this.progressLineWidth = 5.0,
    this.progressLineColor = Purple,
    this.progressInPercent = 0.0,
    this.thumbRadius = 4.0,
    this.thumbColor = DarkPurple,
    this.thumbInPercent = 0.0,
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });



  @override
  _RadialProgressBarState createState() => new _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {

  EdgeInsets customInnerPadding(){

    final halfOfMax = max(widget.trackLineWidth, max((widget.thumbRadius * 2.0), widget.progressLineWidth)) / 2.0;

    return new EdgeInsets.all(halfOfMax) + widget.innerPadding;

  }

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      foregroundPainter: new RadialProgressBarPainter(
        trackLineWidth: widget.trackLineWidth,
        trackLineColor: widget.trackLineColor,
        progressLineWidth: widget.progressLineWidth,
        progressLineColor: widget.progressLineColor,
        progressInPercent: widget.progressInPercent,
        thumbRadius: widget.thumbRadius,
        thumbColor: widget.thumbColor,
        thumbInPercent: widget.thumbInPercent,
      ),
      child: new Padding(
        padding: customInnerPadding(),
        child: widget.child,
      )
    );
  }
}


class RadialProgressBarPainter extends CustomPainter{

  final double trackLineWidth;
//  final Color trackLineColor;
  final Paint trackPaint;

  final double progressLineWidth;
//  final Color progressLineColor;
  final double progressInPercent;
  final Paint progressPaint;

  final double thumbRadius;
//  final Color thumbColor;
  final double thumbInPercent;
  final Paint thumbPaint;


  RadialProgressBarPainter({
    @required this.trackLineWidth,
    @required trackLineColor,
    @required this.progressLineWidth,
    @required progressLineColor,
    @required this.progressInPercent,
    @required this.thumbRadius,
    @required thumbColor,
    @required this.thumbInPercent,
//    this.child,
  }) : trackPaint = new Paint()
        ..color = trackLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackLineWidth,
       progressPaint = new Paint()
        ..color = progressLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = progressLineWidth
        ..strokeCap = StrokeCap.round,
       thumbPaint = new Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill
      ;

  @override
  void paint(Canvas canvas, Size size) {

    final lengthOverflow = max(trackLineWidth, max(progressLineWidth, (thumbRadius * 2.0))); // Finds the width of component that is leaking outside of the container. Thumb width is its diameter.
    final reducedSize = new Size(size.width - lengthOverflow, size.height - lengthOverflow);

    final center = new Offset(size.width / 2, size.height / 2);
    final radius = min(reducedSize.width, reducedSize.height) / 2;
    final progressSweep = 2 * pi * progressInPercent;
    final thumbAngle = 2 * pi * thumbInPercent - (pi / 2); // Because (pi/2) was the starting angle, we need to subtract it to get the absolute angle
    final offsetX = cos(thumbAngle) * radius;
    final offsetY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(offsetX, offsetY) + center;


    // Paint track
    canvas.drawCircle(
      center, // center
      radius, // radius
      trackPaint, // paint
    );



    // Paint progress
    canvas.drawArc(
      // rect, startAngle, sweepAngle, useCenter, paint
      new Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progressSweep,
      false,
      progressPaint
    );

    // Paint Thumb

    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      thumbPaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}