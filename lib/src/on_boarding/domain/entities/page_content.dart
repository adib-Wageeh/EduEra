import 'package:education_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable{

  const PageContent({required this.title,required this.image,
    required this.subTitle,});

  factory PageContent.first(){

    return const PageContent(title: 'Brand new curriculum',
        image: MediaRes.casualReading
        , subTitle: 'This is the first online education platform'
            ' designed by the '
    "world's top professors ",
    );
  }

  factory PageContent.second(){

    return const PageContent(title: 'Brand a fun atmosphere',
      image: MediaRes.casualLife
      , subTitle: 'This is the first online education platform designed by the '
          "world's top professors",
    );
  }

  factory PageContent.third(){

    return const PageContent(title: 'Easy to join the lesson',
      image: MediaRes.casualMeditationScience
      , subTitle: 'This is the first online education platform designed by the '
          "world's top professors",
    );
  }

  final String image;
  final String title;
  final String subTitle;
  
  @override
  List<Object?> get props => [image,title,subTitle];



}