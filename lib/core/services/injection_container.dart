import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/data/datasourses/course_remote_data_source.dart';
import 'package:education_app/core/common/features/course/data/repository/course_repository_impl.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/add_course_use_case.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/get_courses_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/data/dataSource/exam_remote_Data_source.dart';
import 'package:education_app/core/common/features/course/features/exams/data/repository/exam_repo_impl.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exam_questions_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_course_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/get_user_exams_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/submit_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/update_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/use_cases/upload_exam_use_case.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/materials/data/dataSource/resources_reomte_data_source.dart';
import 'package:education_app/core/common/features/course/features/materials/data/repository/resources_repository_impl.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/repository/materials_repo.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/add_resource_use_case.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/get_resources_use_case.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/app/cubit/resource_cubit.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/app/providers/resouce_controller.dart';
import 'package:education_app/core/common/features/course/features/videos/data/data_source/video_remote_data_source.dart';
import 'package:education_app/core/common/features/course/features/videos/data/repos/video_repository_impl.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/add_video_use_case.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/use_cases/get_videos_use_case.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:education_app/src/authentication/data/repository/auth_repository_impl.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:education_app/src/authentication/domain/usecases/forget_password_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/signin_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/signup_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/update_data_usecase.dart';
import 'package:education_app/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/chat/data/dataSource/chat_remote_data_source.dart';
import 'package:education_app/src/chat/data/repos/chat_repo_impl.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';
import 'package:education_app/src/chat/domain/usecases/get_groups_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/get_messages_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/get_user_by_id_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/join_group_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/leave_group_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/send_message_use_case.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:education_app/src/notification/data/datasources/notification_remote_data_source.dart';
import 'package:education_app/src/notification/data/repos/notification_repo_impl.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/add_notification_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/clear_a_notification_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/clear_all_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/get_notifications_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/mark_as_read_use_case.dart';
import 'package:education_app/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:education_app/src/on_boarding/data/datasorces/onboarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/data/repository/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
