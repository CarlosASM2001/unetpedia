import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/ui/subjects/cubit/cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/subject/document_model.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

// Detalles de un documento
class SubjectDocumentView extends StatelessWidget {
  const SubjectDocumentView({super.key, this.document});
  static const String routeName = 'subject_document_view';

  final DocumentModel? document;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit()..setDocument(document),
      child: Scaffold(
        appBar: MainAppBar(title: "Detalles"),
        body: BlocListener<SubjectsCubit, SubjectsState>(
          listenWhen: (p, c) => (p.getDocumentsStatus != c.getDocumentsStatus),
          listener: (context, state) {
            switch (state.getDocumentsStatus) {
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
                //print("TODO BIEN");
                break;

              default:
                break;
            }
          },
          child: _View(),
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
  late SubjectsCubit cubit;

  @override
  void initState() {
    cubit = context.read<SubjectsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Nombre"),
          Text(cubit.state.documentSelected?.name ?? "N/A"),
          SizedBox(height: 10),
          Text("Descripcion"),
          Text(cubit.state.documentSelected?.description ?? "N/A"),
          SizedBox(height: 10),
          Text("Creado"),
          Text(cubit.state.documentSelected?.createdAt?.toString() ?? "N/A"),
          SizedBox(height: 10),
          Text("Extension"),
          Text(cubit.state.documentSelected?.extension ?? "N/A"),
          SizedBox(height: 10),
          Text("Tamaño en bytes"),
          Text(cubit.state.documentSelected?.size?.toString() ?? "N/A"),
          ElevatedButton(
            onPressed: () {
              cubit.downloadFile(
                onAlreadyExists: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Parece que ya tienes este archivo."),
                    ),
                  );
                },
              );
            },
            child: Text("Descargar"),
          ),
          SizedBox(height: 10),
          BlocBuilder<SubjectsCubit, SubjectsState>(
            buildWhen: (p, c) =>
                (p.downloadPercent != c.downloadPercent ||
                p.getDocumentsStatus != c.getDocumentsStatus),
            builder: (context, state) {
              return (state.getDocumentsStatus == WidgetStatus.loading)
                  ? Text(
                      "Descargando... ${((state.downloadPercent ?? 0.0) * 100).toStringAsFixed(2)}%",
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
