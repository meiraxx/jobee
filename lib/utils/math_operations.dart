import 'dart:math';

int generateRandomInteger(int min, int max) => min + Random().nextInt(max - min);

int generateDifferentRandomInteger(int min, int max, int diff) {
  int randomInt = min + Random().nextInt(max - min);

  while (randomInt == diff) {
    randomInt = min + Random().nextInt(max - min);
  }

  return randomInt;
}