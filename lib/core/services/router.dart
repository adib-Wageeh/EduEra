import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/add_exam_view.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/app/cubit/resource_cubit.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/views/add_video_view.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/views/course_videos_view.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/views/video_player_view.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:education_app/core/common/views/page_construction.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/authentication/presentation/views/sign_in_view.dart';
import 'package:education_app/src/authentication/presentation/views/sign_up_view.dart';
import 'package:education_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:education_app/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
