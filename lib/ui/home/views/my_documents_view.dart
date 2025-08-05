import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/generic_error.dart';
import 'package:unetpedia/ui/subjects/cubit/cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/ui/subjects/widgets/subject_card.dart';

// Listado de documentos de un usuario
class MyDocumentsView extends StatelessWidget {
  const MyDocumentsView({super.key});
  static const String routeName = 'my_documents_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubjectsCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MainAppBar(title: "Mis Documentos", isWhite: true),
        body: BlocConsumer<SubjectsCubit, SubjectsState>(
          //listenWhen: (p, c) => (p.genericStatus != c.genericStatus),
          listener: (context, state) {
            /*switch (state.genericStatus) {
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
                context.read<GeneralCubit>().getUser();

                showDialog<void>(
                  context: context,
                  builder: (context) => GenericStatusDialog(),
                );
                break;

              default:
                break;
            }*/
          },
          builder: (context, state) {
            return const _View();
          },
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late SubjectsCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<SubjectsCubit>();
    _cubit.getFilesByUser(FirebaseAuth.instance.currentUser!.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsCubit, SubjectsState>(
      buildWhen: (p, c) => (p.getDocumentsStatus != c.getDocumentsStatus),
      builder: (context, state) {
        switch (state.getDocumentsStatus) {
          case WidgetStatus.loading:
            return const Center(child: LoadingIndicator());
          case WidgetStatus.error:
            return Center(child: GenericError(error: state.exception?.details));
          case WidgetStatus.success:
            return Column(
              children: [
                ((state.documents ?? []).isEmpty)
                    ? Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "No hemos encontrado resultados para tu búsqueda.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.documents?.length ?? 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemBuilder: (context, index) {
                            return SubjectCard(
                              title: state.documents?[index].name ?? "N/A",
                              asset: ConstantImages.yellowCard,
                              onPressed: () {
                                //Navigator.pushNamed(
                                //  context,
                                //  SubjectDocumentView.routeName,
                                //);
                              },
                              onWatch: () {
                                //Navigator.pushNamed(
                                //  context,
                                //  SubjectDocumentView.routeName,
                                //);
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        ),
                      ),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
