library flutter_video_cast;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_video_cast/src/air_play/air_play_platform.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_platform.dart';
import 'package:flutter_video_cast/src/chrome_cast/models/device_entity.dart';
import 'package:flutter_video_cast/src/widgets/sequence_animator.dart';

part 'src/air_play/air_play_button.dart';
part 'src/chrome_cast/chrome_cast_button.dart';
part 'src/chrome_cast/chrome_cast_controller.dart';
part 'src/chrome_cast/chrome_cast_exceptions.dart';
