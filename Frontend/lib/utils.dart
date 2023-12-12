String getSubstringUntilCharacter(String original, String char) {
  int indexOfChar = original.indexOf(char);
  String substring = original.substring(0, indexOfChar != -1 ? indexOfChar : original.length);
  return substring;
}