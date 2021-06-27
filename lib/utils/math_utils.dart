import 'dart:math';

int generateRandomInteger(int min, int max) => min + Random().nextInt(max - min);