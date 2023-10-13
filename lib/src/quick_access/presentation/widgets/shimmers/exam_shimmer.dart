import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ExamShimmer extends StatelessWidget {
  const ExamShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: size.width*0.17,
                        height: size.width*0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width*0.40,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.25,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.20,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),

                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: size.width*0.16,
                        height: size.width*0.16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  )
                ],
              ),
              SizedBox(height: 5.h,),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: size.width*0.17,
                        height: size.width*0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width*0.40,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.25,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.20,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),

                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: size.width*0.16,
                        height: size.width*0.16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  )
                ],
              ),
              SizedBox(height: 5.h,),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: size.width*0.17,
                        height: size.width*0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width*0.40,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.25,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.20,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),

                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: size.width*0.16,
                        height: size.width*0.16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  )
                ],
              ),
              SizedBox(height: 5.h,),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: size.width*0.17,
                        height: size.width*0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width*0.40,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.25,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: size.width*0.20,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),

                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: size.width*0.16,
                        height: size.width*0.16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
