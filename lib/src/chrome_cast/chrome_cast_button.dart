part of flutter_video_cast;

/// Widget that displays the ChromeCast button.
class ChromeCastButton extends StatelessWidget {
  /// Creates a widget displaying a ChromeCast button.
  ChromeCastButton(
      {Key key,
      this.size = 30.0,
      this.color = Colors.white,
      this.connectingColor = Colors.blue,
      this.bottomSheetColor = Colors.white,
      @required this.controller})
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
  final Color connectingColor;

  /// The color of the bottom sheet
  final Color bottomSheetColor;

  final ChromeCastController controller;

  @override
  Widget build(BuildContext context) => Platform.isIOS ? _buildiOSButton(context) : _buildAndroidButton(context);

  Widget _buildiOSButton(BuildContext context) => StreamBuilder(
      initialData: controller.sessionEvent,
      stream: controller.onSessionEvent(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.data is SessionEndedEvent) {
          return GestureDetector(
              onTap: () async {
                final devices = controller.devices;

                await showModalBottomSheet(
                  context: context,
                  backgroundColor: bottomSheetColor,
                  isScrollControlled: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: devices?.length ?? 1,
                          itemBuilder: (context, index) => devices != null
                              ? InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                controller.connect(
                                    deviceId: devices[index].id);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.16))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Text(devices[index].name)))
                              : Text('Discovering devices...'))),
                );
              },
              behavior: HitTestBehavior.translucent,
              child: SvgPicture.asset('assets/icons/ic_cast_24dp.svg',
                  package: 'flutter_video_cast', height: size, color: color));
        } else if (snapshot.data is SessionStartedEvent ||
            snapshot.data is SessionAlreadyConnectedEvent) {
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
                  color: connectingColor),
              SvgPicture.asset('assets/icons/ic_cast1_24dp.svg',
                  package: 'flutter_video_cast',
                  height: size,
                  color: connectingColor),
              SvgPicture.asset('assets/icons/ic_cast2_24dp.svg',
                  package: 'flutter_video_cast',
                  height: size,
                  color: connectingColor),
            ]));
      });

  Widget _buildAndroidButton(BuildContext context) {
    final args = <String, dynamic>{
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
      'alpha': color.alpha
    };
    return SizedBox(
      width: size * 1.5,
      height: size,
      child: AndroidView(
        viewType: 'ChromeCastButton',
        onPlatformViewCreated: (id) => print('ChromeCastButton[$id] created'),
        creationParams: args,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
