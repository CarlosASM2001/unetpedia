import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/ui/cubit/general_cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/generic_error_component.dart';

class SelectDegreeModal extends StatefulWidget {
  const SelectDegreeModal({super.key, required this.onSelected});

  final void Function(CareerModel) onSelected;

  @override
  State<SelectDegreeModal> createState() => _SelectDegreeModalState();
}

class _SelectDegreeModalState extends State<SelectDegreeModal> {
  late GeneralCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<GeneralCubit>();

    if ((_cubit.state.careers ?? []).isEmpty) {
      _cubit.getCareers();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Seleccionar Carrera: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          BlocBuilder<GeneralCubit, GeneralState>(
            buildWhen: (p, c) => (p.careersStatus != c.careersStatus),
            builder: (context, state) {
              switch (state.careersStatus) {
                case WidgetStatus.error:
                  return const Expanded(
                    child: Center(child: GenericErrorComponent()),
                  );

                case WidgetStatus.loading:
                  return const Expanded(
                    child: Center(child: LoadingIndicator()),
                  );

                case WidgetStatus.success:
                  return Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: (state.careers ?? []).length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          final career = state.careers?[index];

                          return _DegreeTile(
                            title: career?.name ?? "N/A",
                            onPresed: () {
                              if (career != null) {
                                widget.onSelected(career);
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _DegreeTile extends StatelessWidget {
  const _DegreeTile({required this.title, required this.onPresed});

  final String title;
  final VoidCallback onPresed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPresed,
      title: Text(title),
      leading: const Icon(Icons.menu_book_rounded),
    );
  }
}
