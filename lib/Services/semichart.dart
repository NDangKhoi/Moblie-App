import 'dart:math';
import 'dart:ui';

double degToRad(num deg) => deg * (pi / 180);
num normalize(value, min, max) => (value - min) / (max - min);
const Color kScaffoldBackgroundColor = Color(0xff2e48a3);
const double kDiameter = 300;
const double kMinDegree = 2;
const double kMaxDegree = 16;
