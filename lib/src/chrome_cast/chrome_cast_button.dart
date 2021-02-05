part of flutter_video_cast;

/// Callback method for when the button is ready to be used.
///
/// Pass to [ChromeCastButton.onButtonCreated] to receive a [ChromeCastController]
/// when the button is created.
typedef OnButtonCreated = void Function(ChromeCastController controller);

/// Callback method for when a request has failed.
typedef OnRequestFailed = void Function(String error);

/// Widget that displays the ChromeCast button.
class ChromeCastButton extends StatelessWidget {
  /// Creates a widget displaying a ChromeCast button.
  ChromeCastButton(
      {Key key,
      this.size = 30.0,
      this.color = Colors.white,
      this.connectColor = Colors.blue,
      this.bottomSheetColor = Colors.white,
      @required this.controller,
      this.onButtonCreated,
      this.onSessionStarted,
      this.onSessionEnded,
      this.onRequestCompleted,
      this.onRequestFailed})
      : assert(
            defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android,
            '$defaultTargetPlatform is not supported by this plugin'),
        super(key: key);

  /// The size of the button.
  final double size;

  /// The color of the button.
  final Color color;

  /// The color of the button when connecting to a device
  final Color connectColor;

  /// The color of the bottom sheet
  final Color bottomSheetColor;

  /// Callback method for when the button is ready to be used.
  ///
  /// Used to receive a [ChromeCastController] for this [ChromeCastButton].
  final OnButtonCreated onButtonCreated;

  /// Called when a cast session has started.
  final VoidCallback onSessionStarted;

  /// Called when a cast session has ended.
  final VoidCallback onSessionEnded;

  /// Called when a cast request has successfully completed.
  final VoidCallback onRequestCompleted;

  /// Called when a cast request has failed.
  final OnRequestFailed onRequestFailed;

  final ChromeCastController controller;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    // stream: Future.delayed(Duration.zero).asStream(),
      stream: controller.events.where((event) =>
          event is SessionStartedEvent ||
          event is SessionEndedEvent ||
          event is SessionConnectingEvent),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.data is SessionEndedEvent) {
          return GestureDetector(
              onTap: () async {
                final devices = await controller.discoverDevices();

                await showModalBottomSheet(
                  context: context,
                  backgroundColor: bottomSheetColor,
                  isScrollControlled: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: devices.length,
                          itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                controller.connect(deviceId: devices[index].id);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.16))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Text(devices[index].name))))),
                );
              },
              behavior: HitTestBehavior.translucent,
              child: SvgPicture.asset('assets/icons/ic_cast_24dp.svg',
                  package: 'flutter_video_cast', height: size, color: color));
        } else if (snapshot.data is SessionStartedEvent) {
          return GestureDetector(
              onTap: () => controller.disconnect(),
              behavior: HitTestBehavior.translucent,
              child: SvgPicture.asset('assets/icons/ic_cast_connected_24dp.svg',
                  package: 'flutter_video_cast', height: size, color: color));
        }

        return GestureDetector(
            onTap: () => controller.disconnect(),
            behavior: HitTestBehavior.translucent,
            child: SequenceAnimator(childrenSequence: [
              SvgPicture.asset('assets/icons/ic_cast0_24dp.svg',
                  package: 'flutter_video_cast',
                  height: size,
                  color: connectColor),
              SvgPicture.asset('assets/icons/ic_cast1_24dp.svg',
                  package: 'flutter_video_cast',
                  height: size,
                  color: connectColor),
              SvgPicture.asset('assets/icons/ic_cast2_24dp.svg',
                  package: 'flutter_video_cast',
                  height: size,
                  color: connectColor),
            ]));
      });
}
