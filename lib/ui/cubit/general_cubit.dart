import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/subject/subject.dart';
import 'package:unetpedia/providers/firestore_provider.dart';
import 'package:unetpedia/providers/authentication_provider.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(const GeneralState());

  final _firestoreProvider = FirestoreProvider();
  final _authenticationProvider = AuthenticationProvider();

  void clean() => emit(const GeneralState());

  /// Aplica filtrado por nombre al listado de departamentos
  void setDepartmentQuery(String value) {
    emit(state.copyWith(departmentsQuery: value));

    if ((state.departments ?? []).isEmpty) return;

    // Si el valor es vacio, se limpian los filtros
    if (value.isEmpty) {
      emit(state.copyWith(departmentsFiltered: Wrapped.value(null)));
      return;
    }

    // Encontrando coincidencias en la lista
    final values = state.departments
        ?.where((e) => (e.name!.toLowerCase().contains(value.toLowerCase())))
        .toList();

    // Aplicando el filtro localmente
    emit(state.copyWith(departmentsFiltered: Wrapped.value(values)));
  }

  //void setSubjectQuery(String value) {
  //  emit(
  //    state.copyWith(
  //      subjectQuery: value,
  //      subjectsResponseModel: const Wrapped.value(null),
  //    ),
  //  );
  //}

  // void selectCategory(CategoryResponseModel? value) {
  //   emit(
  //     state.copyWith(
  //       departmentSelected: Wrapped.value(value),
  //       //subjectsResponseModel: const Wrapped.value(null),
  //       subjectsStatus: WidgetStatus.initial,
  //       moreSubjectsStatus: WidgetStatus.initial,
  //       subjectQuery: "",
  //     ),
  //   );
  // }

  //void selectSubject(SubjectResponseModel? value) {
  //  emit(state.copyWith(subjectSelected: Wrapped.value(value)));
  //}

  // =======================================================================
  // Careers
  // =======================================================================

  Future<void> getCareers() async {
    if (state.careersStatus == WidgetStatus.loading) return;
    emit(state.copyWith(careersStatus: WidgetStatus.loading));

    final resp = await _firestoreProvider.getCareers();

    return resp.fold(
      (l) {
        emit(state.copyWith(careersStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(
          state.copyWith(
            careersStatus: WidgetStatus.success,
            careers: Wrapped.value(r),
          ),
        );
      },
    );
  }

  // =======================================================================
  // Authentication
  // =======================================================================

  Future<void> getUser() async {
    if (state.user != null) return;
    if (state.getUserStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getUserStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );

    return response.fold(
      (l) {
        emit(state.copyWith(getUserStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        // Verificando si la lista de carreras esta vacia para consumir
        // la peticion
        if ((state.careers ?? []).isEmpty) {
          await getCareers();
        }

        // Determinando la carrera del usuario para guardarla en el state¿
        final userCareer = state.careers?.firstWhere(
          (e) => (e.id == r.careerId),
        );

        emit(
          state.copyWith(
            getUserStatus: WidgetStatus.success,
            user: Wrapped.value(r),
            userCareer: Wrapped.value(userCareer),
          ),
        );
      },
    );
  }

  Future<void> logOut() async {
    if (state.logOutStatus == WidgetStatus.loading) return;
    emit(state.copyWith(logOutStatus: WidgetStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final response = await _authenticationProvider.logOut();

    return response.fold(
      (l) {
        emit(state.copyWith(logOutStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(state.copyWith(logOutStatus: WidgetStatus.success));
      },
    );
  }

  // =======================================================================
  // Categories (Departments)
  // =======================================================================

  Future<void> getDepartments() async {
    if (state.departmentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(departmentsStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getDepartments();

    return response.fold(
      (l) {
        emit(
          state.copyWith(departmentsStatus: WidgetStatus.error, exception: l),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            departmentsStatus: WidgetStatus.success,
            departments: Wrapped.value(r),
          ),
        );
      },
    );
  }

  // =======================================================================
  // Subjects
  // =======================================================================

  // Subjects List with pagination
  /*Future<void> getSubjects() async {
    if (state.subjectsStatus == WidgetStatus.loading ||
        state.moreSubjectsStatus == WidgetStatus.loading) {
      return;
    }

    int? page = 1;

    if (state.subjectsResponseModel != null) {
      if ((state.subjectsResponseModel?.pages?.next) == null) return;

      page = state.subjectsResponseModel?.pages?.next;
    }

    if (page != 1) {
      emit(state.copyWith(moreSubjectsStatus: WidgetStatus.loading));
    } else {
      emit(state.copyWith(subjectsStatus: WidgetStatus.loading));
    }

    final response = await _genericProvider.getSubjects(
      page: page!,
      categoryId: state.departmentSelected!.id!,
      query: state.subjectQuery,
    );

    return response.fold(
      (l) {
        if (page != 1) {
          emit(
            state.copyWith(
              moreSubjectsStatus: WidgetStatus.error,
              errorText: l.details,
            ),
          );
        } else {
          emit(
            state.copyWith(
              subjectsStatus: WidgetStatus.error,
              errorText: l.details,
            ),
          );
        }
      },
      (r) async {
        emit(
          state.copyWith(
            subjectsStatus: WidgetStatus.success,
            moreSubjectsStatus: WidgetStatus.success,
            subjectsResponseModel: Wrapped.value(
              (state.subjectsResponseModel ?? SubjectsResponseModel()).copyWith(
                data: [
                  ...(state.subjectsResponseModel?.data ?? []),
                  ...r.data!,
                ],
                pages: r.pages,
                count: r.count,
              ),
            ),
          ),
        );
      },
    );
  }*/
}
