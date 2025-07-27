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
    //this.subjectsResponseModel,
    this.departmentSelected,
    this.moreSubjectsStatus = WidgetStatus.initial,
    //this.subjectSelected,
    this.departmentsQuery = "",
    this.subjectQuery = "",
    this.user,
    this.userCareer,
    this.departmentsFiltered,
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
  final WidgetStatus moreSubjectsStatus;
  //final SubjectResponseModel? subjectSelected;
  //final SubjectsResponseModel? subjectsResponseModel;

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
    //subjectsResponseModel,
    departmentSelected,
    moreSubjectsStatus,
    //subjectSelected,
    departmentsQuery,
    subjectQuery,
    user,
    userCareer,
    departmentsFiltered,
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
    //Wrapped<SubjectsResponseModel?>? subjectsResponseModel,
    Wrapped<DepartmentModel?>? departmentSelected,
    WidgetStatus? moreSubjectsStatus,
    //Wrapped<SubjectResponseModel?>? subjectSelected,
    String? departmentsQuery,
    String? subjectQuery,
    Wrapped<UserResponseModel?>? user,
    Wrapped<CareerModel?>? userCareer,
    Wrapped<List<DepartmentModel>?>? departmentsFiltered,
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
      //subjectsResponseModel: subjectsResponseModel != null
      //    ? subjectsResponseModel.value
      //    : this.subjectsResponseModel,
      departmentSelected: departmentSelected != null
          ? departmentSelected.value
          : this.departmentSelected,
      moreSubjectsStatus: moreSubjectsStatus ?? this.moreSubjectsStatus,
      //subjectSelected: subjectSelected != null
      //    ? subjectSelected.value
      //    : this.subjectSelected,
      departmentsQuery: departmentsQuery ?? this.departmentsQuery,
      subjectQuery: subjectQuery ?? this.subjectQuery,
      user: user != null ? user.value : this.user,
      userCareer: userCareer != null ? userCareer.value : this.userCareer,
      departmentsFiltered: departmentsFiltered != null
          ? departmentsFiltered.value
          : this.departmentsFiltered,
    );
  }
}
