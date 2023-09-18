import 'dart:ui';

class Colours {
  const Colours._();
  /// #EDF8FF #FDC1E8, #FDFAE1, #FFFFFF
  static const gradient = [
    Color(0xFFEDF8FF),
    Color(0xFFFDC1E8),
    Color(0xFFFFFFFF),
    Color(0xFFFDFAE1),
  ];

  /// #458CFF
  static const primaryColour = Color(0xFF458CFF);

  /// #757C8E
  static const neutralTextColour = Color(0xFF757C8E);

  /// #D3D5FE
  static const physicsTileColour = Color(0xFFD3D5FE);

  /// #FFEFDA
  static const scienceTileColour = Color(0xFFFFEFDA);

  /// #FFE4F1
  static const chemistryTileColour = Color(0xFFFFE4F1);

  /// #CFE5FC
  static const biologyTileColour = Color(0xFFCFE5FC);

  /// #FFCECA
  static const mathTileColour = Color(0xFFFFCECA);

  /// #DAFFD6
  static const languageTileColour = Color(0xFFDAFFD6);

  /// #D5BEFB
  static const literatureTileColour = Color(0xFFD5BEFB);

  /// #FF5C5C
  static const redColour = Color(0xFFFF5C5C);

  /// #28CA6C
  static const greenColour = Color(0xFF28CA6C);

  /// #F4F5F6
  static const chatFieldColour = Color(0xFFF4F5F6);

  /// #E8E9EA
  static const chatFieldColourDarker = Color(0xFFE8E9EA);

  static const currentUserChatBubbleColour = Color(0xFF2196F3);

  static const otherUserChatBubbleColour = Color(0xFFEEEEEE);

  static const currentUserChatBubbleColourDarker = Color(0xFF1976D2);

  static const otherUserChatBubbleColourDarker = Color(0xFFE0E0E0);

  static const List<TinderCardsColors> tinderColors = [
    TinderCardsColors(backGroundColor: Color(0xFFDA92FC),
        gradiantBottomColor: Color(0xFF8E96FF),
        gradiantTopColor: Color(0xFFA06AF9),),

    TinderCardsColors(backGroundColor: Color(0xFFDA92FC),
      gradiantBottomColor: Color(0xFF9796f0),
      gradiantTopColor: Color(0xFFFBC7D4),),

    TinderCardsColors(backGroundColor: Color(0xFFDA92FC),
      gradiantBottomColor: Color(0xFFacb6e5),
      gradiantTopColor: Color(0xFF86fde8),),
    TinderCardsColors(backGroundColor: Color(0xFFDA92FC),
      gradiantBottomColor: Color(0xFFFFF6B7),
      gradiantTopColor: Color(0xFFF6416C),),
    TinderCardsColors(backGroundColor: Color(0xFFDA92FC),
      gradiantBottomColor: Color(0xFFABDCFF),
      gradiantTopColor: Color(0xFF0396FF),),

  ];

}

class TinderCardsColors{

  const TinderCardsColors({
    required this.backGroundColor,
    required this.gradiantBottomColor,
    required this.gradiantTopColor,
});

  final Color backGroundColor;
  final Color gradiantTopColor;
  final Color gradiantBottomColor;

  static TinderCardsColors tinderRandomColors(){
   final colors = List<TinderCardsColors>.from(Colours.tinderColors)
      ..shuffle();
   return colors.first;
  }

}
