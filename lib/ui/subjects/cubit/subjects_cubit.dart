import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/wrapped.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/providers/firestore_provider.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/subject/document_model.dart';
import 'package:unetpedia/models/generic/data_exception_model.dart';
import 'package:unetpedia/models/subject/document_request_model.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit() : super(const SubjectsState());

  final _firestoreProvider = FirestoreProvider();

  // void setDocumentsQuery(String value) {
  //   emit(
  //     state.copyWith(
  //       documentsQuery: value,
  //       documents: const Wrapped.value(null),
  //     ),
  //   );
  // }

  void selectFile(FileModel value) =>
      emit(state.copyWith(fileSelected: Wrapped.value(value)));

  // ========================================================================
  // Get Documents
  // ========================================================================

  Future<void> getFilesBySubject({
    required String? departmentId,
    required String? subjectId,
  }) async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    if ((departmentId ?? "").isEmpty || (subjectId ?? "").isEmpty) {
      emit(
        state.copyWith(
          getDocumentsStatus: WidgetStatus.error,
          exception: DataException(
            details: "No hemos podido realizar la consulta.",
          ),
        ),
      );
      return;
    }

    final response = await _firestoreProvider.getFilesBySubject(
      departmentId: departmentId!,
      subjectId: subjectId!,
    );

    return response.fold(
      (l) {
        emit(
          state.copyWith(getDocumentsStatus: WidgetStatus.error, exception: l),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            getDocumentsStatus: WidgetStatus.success,
            documents: Wrapped.value(r),
          ),
        );
      },
    );
  }

  Future<void> getFilesByUser(String userId) async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getFilesByUser(userId: userId);

    return response.fold(
      (l) {
        emit(
          state.copyWith(getDocumentsStatus: WidgetStatus.error, exception: l),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            getDocumentsStatus: WidgetStatus.success,
            documents: Wrapped.value(r),
          ),
        );
      },
    );
  }

  /*Future<void> getDocumentDetail() async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    final response = await _documentsProvider.getDocument(docId: 26);

    return response.fold(
      (l) {
        emit(
          state.copyWith(
            getDocumentsStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            //getDocumentsStatus: WidgetStatus.success,
            documentDetail: Wrapped.value(r.data),
          ),
        );
        await _download();
      },
    );
  }*/

  // ========================================================================
  // Upload Documents
  // ========================================================================

  // Se sube un archivo al storage y se crea el documento en la base de datos
  Future<void> createDocument({
    required String tile,
    required String? userId,
    required String? departmentId,
    required String? subjectId,
  }) async {
    if (state.uploadStatus == WidgetStatus.loading ||
        state.fileSelected?.file == null) {
      return;
    }
    emit(state.copyWith(uploadStatus: WidgetStatus.loading));

    if ((userId ?? "").isEmpty ||
        (departmentId ?? "").isEmpty ||
        (subjectId ?? "").isEmpty) {
      emit(
        state.copyWith(
          getDocumentsStatus: WidgetStatus.error,
          exception: DataException(
            details: "No hemos podido realizar la consulta.",
          ),
        ),
      );
      return;
    }

    // 1. Subiendo el archivo seleccionado
    final fileUrl = await _firestoreProvider.uploadFile(
      storagePath: StoragePath.files,
      path:
          "$userId/${DateTime.now().toString()}${state.fileSelected!.getExtension}",
      file: state.fileSelected!.file,
    );

    // 2. Creando el documento
    final response = await _firestoreProvider.createFileDocument(
      userId: userId!,
      departmentId: departmentId!,
      subjectId: subjectId!,
      data: DocumentRequestModel(
        name: tile,
        url: fileUrl,
        size: state.fileSelected!.getSizeInBytes,
        extension: state.fileSelected!.getExtension,
      ),
    );

    return response.fold(
      (l) {
        emit(state.copyWith(uploadStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        //await _uploadDocument(r.presignedUrl);
        emit(state.copyWith(uploadStatus: WidgetStatus.success));
      },
    );
  }

  // Download
  /*Future<void> _download() async {
    final file = await GenericUtils.checkDownloadFile(
      url: state.documentDetail!.url!,
      fileName: state.documentDetail!.name!,
    );

    emit(
      state.copyWith(
        fileSelected: Wrapped.value(
          FileModel(id: "0", name: "name", file: file!),
        ),
        getDocumentsStatus: WidgetStatus.success,
      ),
    );
  }*/
}
