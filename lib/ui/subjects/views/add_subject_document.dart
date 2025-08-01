import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/ui/subjects/cubit/cubit.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/modals/upload_file_modal.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

// Formulario para agregar documentos a la materia seleccionada
class AddSubjectDocumentView extends StatelessWidget {
  const AddSubjectDocumentView({super.key});
  static const String routeName = 'add_subject_document_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MainAppBar(title: "Subir Archivo", isWhite: true),
        body: BlocListener<SubjectsCubit, SubjectsState>(
          listenWhen: (p, c) => (p.uploadStatus != c.uploadStatus),
          listener: (context, state) {
            switch (state.uploadStatus) {
              case WidgetStatus.loading:
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => PopScope(
                    canPop: false,
                    child: Center(child: LoadingIndicator()),
                  ),
                );
                break;

              case WidgetStatus.error:
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => GenericStatusDialog(
                    description: state.exception?.details,
                    isErrorDialog: true,
                  ),
                );
                break;

              case WidgetStatus.success:
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PopScope(
                    canPop: false,
                    child: GenericStatusDialog(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
                break;

              default:
                break;
            }
          },
          child: const _View(),
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  final _formKey = GlobalKey<FormState>();

  late SubjectsCubit _cubit;
  late GeneralCubit _generalCubit;
  late TextEditingController _titleController;

  @override
  void initState() {
    _cubit = context.read<SubjectsCubit>();
    _generalCubit = context.read<GeneralCubit>();

    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _documentSelectionModal() {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return UploadFileModal(onGetFile: (file) => _cubit.selectFile(file));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                FormInput(
                  labelText: "Título",
                  hintText: "Ingresar título",
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  validator: (value) => Validators.emptyValidation(value),
                ),
                const SizedBox(height: 24),
                BlocBuilder<SubjectsCubit, SubjectsState>(
                  buildWhen: (p, c) => (p.fileSelected != c.fileSelected),
                  builder: (context, state) {
                    return _UploadFile(
                      file: state.fileSelected,
                      onPressed: () => _documentSelectionModal(),
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<SubjectsCubit, SubjectsState>(
            buildWhen: (p, c) => (p.fileSelected != c.fileSelected),
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: GenericButton(
                  text: "Subir Archivo",
                  onTap: (state.fileSelected != null)
                      ? () {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (_formKey.currentState!.validate() &&
                              state.fileSelected != null) {
                            _cubit.createDocument(
                              tile: _titleController.text.trim(),
                              userId: _generalCubit.state.user?.uid,
                              departmentId:
                                  _generalCubit.state.departmentSelected?.id,
                              subjectId:
                                  _generalCubit.state.subjectSelected?.id,
                            );
                          }
                        }
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UploadFile extends StatelessWidget {
  const _UploadFile({this.file, required this.onPressed});

  final FileModel? file;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: (file != null)
              ? ConstantColors.cff141718.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(color: ConstantColors.cff141718),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_upload_rounded,
              size: 38,
              color: (file != null)
                  ? ConstantColors.cff141718
                  : const Color(0xFFAFAFAF),
            ),
            const SizedBox(height: 16),
            Text(
              (file != null)
                  ? "${file?.name} ${file?.getSizeInFormattedString}"
                  : "Subir Archivo",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: (file != null)
                    ? ConstantColors.cff141718
                    : const Color(0xFFAFAFAF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
