class StringUtils{
  static String toCalmelCase(String string){
    return string
        .split(' ')
        .map((word) => word[0].toUpperCase()+word.substring(1).toLowerCase())
        .join(' ');
  }

  static String formatDateTime(DateTime dateTime){
    return "${addZero(dateTime.day)}/${addZero(dateTime.month)}/${dateTime.year} à ${dateTime.hour}h${addZero(dateTime.minute)}";
  }

  static String addZero(int number){
    return number<10 ? "0$number" : number.toString();
  }
}