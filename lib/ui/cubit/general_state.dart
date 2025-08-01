part of 'general_cubit.dart';

class GeneralState extends Equatable {
  const GeneralState({
    this.exception,
    this.careers,
    this.careersStatus = WidgetStatus.initial,
    this.getUserStatus = WidgetStatus.initial,
    this.logOutStatus = WidgetStatus.initial,
    this.departmentsStatus = WidgetStatus.initial,
    this.departments,
    this.subjectsStatus = WidgetStatus.initial,
    this.subjects,
    this.departmentSelected,
    this.subjectSelected,
    this.departmentsQuery = "",
    this.subjectQuery = "",
    this.user,
    this.userCareer,
    this.departmentsFiltered,
    this.subjectsFiltered,
  });

  // General
  final DataException? exception;
  final CareerModel? userCareer;

  // Careers
  final WidgetStatus careersStatus;
  final List<CareerModel>? careers;

  // Authentication
  final UserResponseModel? user;
  final WidgetStatus getUserStatus;
  final WidgetStatus logOutStatus;

  // Departaments
  final String departmentsQuery;
  final WidgetStatus departmentsStatus;
  final DepartmentModel? departmentSelected;
  final List<DepartmentModel>? departments;
  final List<DepartmentModel>? departmentsFiltered;

  // Subjects
  final String subjectQuery;
  final WidgetStatus subjectsStatus;
  final List<SubjectModel>? subjects;
  final List<SubjectModel>? subjectsFiltered;
  final SubjectModel? subjectSelected;

  @override
  List<Object?> get props => [
    exception,
    careers,
    careersStatus,
    getUserStatus,
    logOutStatus,
    departmentsStatus,
    departments,
    subjectsStatus,
    subjects,
    departmentSelected,
    subjectSelected,
    departmentsQuery,
    subjectQuery,
    user,
    userCareer,
    departmentsFiltered,
    subjectsFiltered,
  ];

  GeneralState copyWith({
    DataException? exception,
    Wrapped<List<CareerModel>?>? careers,
    WidgetStatus? careersStatus,
    WidgetStatus? getUserStatus,
    WidgetStatus? logOutStatus,
    WidgetStatus? departmentsStatus,
    Wrapped<List<DepartmentModel>?>? departments,
    WidgetStatus? subjectsStatus,
    Wrapped<List<SubjectModel>?>? subjects,
    Wrapped<DepartmentModel?>? departmentSelected,
    Wrapped<SubjectModel?>? subjectSelected,
    String? departmentsQuery,
    String? subjectQuery,
    Wrapped<UserResponseModel?>? user,
    Wrapped<CareerModel?>? userCareer,
    Wrapped<List<DepartmentModel>?>? departmentsFiltered,
    Wrapped<List<SubjectModel>?>? subjectsFiltered,
  }) {
    return GeneralState(
      exception: exception ?? this.exception,
      careers: careers != null ? careers.value : this.careers,
      careersStatus: careersStatus ?? this.careersStatus,
      getUserStatus: getUserStatus ?? this.getUserStatus,
      logOutStatus: logOutStatus ?? this.logOutStatus,
      departmentsStatus: departmentsStatus ?? this.departmentsStatus,
      departments: departments != null ? departments.value : this.departments,
      subjectsStatus: subjectsStatus ?? this.subjectsStatus,
      subjects: subjects != null ? subjects.value : this.subjects,
      departmentSelected: departmentSelected != null
          ? departmentSelected.value
          : this.departmentSelected,
      subjectSelected: subjectSelected != null
          ? subjectSelected.value
          : this.subjectSelected,
      departmentsQuery: departmentsQuery ?? this.departmentsQuery,
      subjectQuery: subjectQuery ?? this.subjectQuery,
      user: user != null ? user.value : this.user,
      userCareer: userCareer != null ? userCareer.value : this.userCareer,
      departmentsFiltered: departmentsFiltered != null
          ? departmentsFiltered.value
          : this.departmentsFiltered,
      subjectsFiltered: subjectsFiltered != null
          ? subjectsFiltered.value
          : this.subjectsFiltered,
    );
  }
}
