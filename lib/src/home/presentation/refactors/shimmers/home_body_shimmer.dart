import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeBodyShimmer extends StatelessWidget {
  const HomeBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(baseColor: Colors.grey.shade300,
              highlightColor: Colors.white, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey,
                width: size.width*0.25,
                height: size.height*0.07,
              ),
               SizedBox(
                height: 15.sp,
              ),
              Container(
                color: Colors.grey,
                width: size.width *0.5,
                height: size.height*0.07,
              ),
               SizedBox(
                height: 10.sp,
              ),
              Align(
                child: SizedBox(
                  height: 130.h,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: size.width *0.85,
                        height: 110.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width *0.75,
                          height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width *0.65,
                          height: 130.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(
                height: 25.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey,
                        width: size.width*0.25,
                        height: size.height*0.04,
                      ),
                       SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        color: Colors.grey,
                        width: size.width*0.4,
                        height: size.height*0.04,
                      ),

                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    width: size.width*0.25,
                    height: size.height*0.04,
                  ),

                ],
              ),
              SizedBox(
                height: 25.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: size.width*0.20,
                        height: size.width*0.20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Container(
                        color: Colors.grey,
                        width: size.width*0.20,
                        height: size.width*0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Column(
                    children: [
                      Container(
                        width: size.width*0.20,
                        height: size.width*0.20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Container(
                        color: Colors.grey,
                        width: size.width*0.20,
                        height: size.width*0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Column(
                    children: [
                      Container(
                        width: size.width*0.20,
                        height: size.width*0.20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Container(
                        color: Colors.grey,
                        width: size.width*0.20,
                        height: size.width*0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Column(
                    children: [
                      Container(
                        width: size.width*0.20,
                        height: size.width*0.20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Container(
                        color: Colors.grey,
                        width: size.width*0.20,
                        height: size.width*0.05,
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),),
        ),
      ],
    );
  }
}
