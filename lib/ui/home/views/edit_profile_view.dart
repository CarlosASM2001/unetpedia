import 'package:flutter/material.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/ui/authentication/cubit/cubit.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';
import 'package:unetpedia/ui/authentication/register/widgets/photo_component.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});
  static const String routeName = 'edit_profile_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MainAppBar(title: "Editar Perfil", isWhite: true),
        body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listenWhen: (p, c) => (p.genericStatus != c.genericStatus),
          listener: (context, state) {
            switch (state.genericStatus) {
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
                    description: state.errorText,
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
            }
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
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  late AuthenticationCubit _cubit;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _cubit = context.read<AuthenticationCubit>();
    final user = context.read<GeneralCubit>().state.user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
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
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  buildWhen: (p, c) => (p.photoSelected != c.photoSelected),
                  builder: (context, state) {
                    return PhotoComponent(
                      path: context.read<GeneralCubit>().state.user?.photoUrl,
                      imageSelected: state.photoSelected,
                      onGetImage: (photo) => _cubit.setImage(photo),
                    );
                  },
                ),
                const SizedBox(height: 24),
                FormInput(
                  labelText: "Nombre",
                  hintText: "Ingresa tu nombre",
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => Validators.emptyValidation(value),
                ),
                const SizedBox(height: 24),
                FormInput(
                  labelText: "Apellido",
                  hintText: "Ingresa tu apellido",
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => Validators.emptyValidation(value),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: GenericButton(
              text: "Guardar Cambios",
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();

                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationCubit>().updateUserProfile(
                    name: _nameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
