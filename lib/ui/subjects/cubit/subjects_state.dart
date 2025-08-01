part of 'subjects_cubit.dart';

class SubjectsState extends Equatable {
  const SubjectsState({
    this.exception,
    this.getDocumentsStatus = WidgetStatus.initial,
    this.documents,
    this.documentsQuery = "",
    this.uploadStatus = WidgetStatus.initial,
    this.fileSelected,
  });

  // General
  final DataException? exception;

  // Get Documents
  final String documentsQuery;
  final List<DocumentModel>? documents;
  final WidgetStatus getDocumentsStatus;

  // Upload Document
  final WidgetStatus uploadStatus;
  final FileModel? fileSelected;

  @override
  List<Object?> get props => [
    exception,
    getDocumentsStatus,
    documents,
    documentsQuery,
    uploadStatus,
    fileSelected,
  ];

  SubjectsState copyWith({
    DataException? exception,
    WidgetStatus? getDocumentsStatus,
    Wrapped<List<DocumentModel>?>? documents,
    String? documentsQuery,
    WidgetStatus? uploadStatus,
    Wrapped<FileModel?>? fileSelected,
  }) {
    return SubjectsState(
      exception: exception ?? this.exception,
      getDocumentsStatus: getDocumentsStatus ?? this.getDocumentsStatus,
      documents: documents != null ? documents.value : this.documents,
      documentsQuery: documentsQuery ?? this.documentsQuery,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      fileSelected: fileSelected != null
          ? fileSelected.value
          : this.fileSelected,
    );
  }
}
