import 'package:education_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable{

  const PageContent({required this.title,required this.image,
    required this.subTitle,required this.index,});

  factory PageContent.first(){

    return const PageContent(title: 'Brand new curriculum',
        image: MediaRes.casualReading
        , subTitle: 'This is the first online education platform'
            ' designed by the '
    "world's top professors ",
      index: 0,
    );
  }

  factory PageContent.second(){

    return const PageContent(title: 'Brand a fun atmosphere',
      image: MediaRes.casualLife
      , subTitle: 'This is the first online education platform designed by the '
          "world's top professors",
      index: 1,
    );
  }

  factory PageContent.third(){

    return const PageContent(title: 'Easy to join the lesson',
      image: MediaRes.casualMeditationScience
      , subTitle: 'This is the first online education platform designed by the '
          "world's top professors",
      index: 2,
    );
  }

  final String image;
  final String title;
  final String subTitle;
  final int index;
  
  @override
  List<Object?> get props => [image,title,subTitle,index];



}