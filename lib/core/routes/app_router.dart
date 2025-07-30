import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/qualifications/cubit/grade_calculator_cubit.dart';
import 'package:unetpedia/ui/qualifications/qualifications_view.dart';
import 'package:unetpedia/ui/qualifications/tutors_view.dart';
import 'package:unetpedia/ui/ui.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (BuildContext contex) => const App(),

    // Authentication
    LoginView.routeName: (BuildContext contex) => const LoginView(),
    RegisterView.routeName: (BuildContext contex) => const RegisterView(),
    ForgotPasswordView.routeName: (BuildContext contex) =>
        const ForgotPasswordView(),

    // Home
    HomeView.routeName: (BuildContext contex) => const HomeView(),
    SettingsView.routeName: (context) => const SettingsView(),
    UpdatePasswordView.routeName: (context) => const UpdatePasswordView(),

    // Departments
    DepartmentsView.routeName: (BuildContext contex) => const DepartmentsView(),

    // Subjects
    SubjectsView.routeName: (BuildContext contex) => const SubjectsView(),
    SubjectDetailView.routeName: (BuildContext contex) =>
        const SubjectDetailView(),
    AddSubjectDocumentView.routeName: (context) =>
        const AddSubjectDocumentView(),
    SubjectDocumentView.routeName: (context) => const SubjectDocumentView(),

    // Qualification
    QualificationView.routeName: (context) => BlocProvider(
      create: (context) => GradeCalculatorCubit(),
      child: const QualificationView(),
    ),

    //
    TutorsView.routeName: (context) => const TutorsView(),
  };
}
