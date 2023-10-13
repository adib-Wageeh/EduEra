import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CourseShimmer extends StatelessWidget {
  const CourseShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
        highlightColor: Colors.white,
      child:
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
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
      ),);
  }
}
