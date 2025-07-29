import 'package:flutter/material.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/ui/subjects/views/subjects_view.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});
  static const String routeName = 'departments_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Departamentos"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          const SizedBox(height: 28),
          const Expanded(child: _Content()),
        ],
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late GeneralCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<GeneralCubit>();

    if ((_cubit.state.departments ?? []).isEmpty) {
      _cubit.getDepartments();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralCubit, GeneralState>(
      buildWhen: (p, c) => (p.departmentsStatus != c.departmentsStatus),
      builder: (context, state) {
        switch (state.departmentsStatus) {
          case WidgetStatus.loading:
            return const Center(child: LoadingIndicator());
          case WidgetStatus.error:
            return Center(child: GenericError(error: state.exception?.details));
          case WidgetStatus.success:
            return Column(
              children: [
                const GenericTitle(title: "Departamento"),
                const SizedBox(height: 16),
                BlocBuilder<GeneralCubit, GeneralState>(
                  buildWhen: (p, c) =>
                      (p.departmentsFiltered != c.departmentsFiltered),
                  builder: (context, state) {
                    // Bandera para renderizar el listado filtrado
                    final bool applyFilter =
                        (state.departmentsFiltered != null);

                    if ((applyFilter)
                        ? ((state.departmentsFiltered ?? []).isEmpty)
                        : ((state.departments ?? []).isEmpty)) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "No hemos encontrado resultados para tu búsqueda.",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        itemCount: (applyFilter)
                            ? (state.departmentsFiltered?.length ?? 0)
                            : (state.departments?.length ?? 0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemBuilder: (context, index) {
                          final department = (applyFilter)
                              ? (state.departmentsFiltered?[index])
                              : (state.departments?[index]);

                          return GenericCard(
                            title: department?.name ?? "N/A",
                            subtitle: "0 Materias",
                            asset: ConstantImages.blueCard,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();

                              _cubit.setSubjectQuery("");
                              _cubit.selectDepartment(department);
                              Navigator.pushNamed(
                                context,
                                SubjectsView.routeName,
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                      ),
                    );
                  },
                ),
              ],
            );
          default:
            return const Placeholder();
        }
      },
    );
  }
}

class _Header extends StatelessWidget {
  _Header();

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      child: SearchInput(
        controller: TextEditingController(
          text: context.read<GeneralCubit>().state.departmentsQuery,
        ),
        hintText: "Buscar departamento",
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            context.read<GeneralCubit>().setDepartmentQuery(value);
          });
        },
      ),
    );
  }
}
