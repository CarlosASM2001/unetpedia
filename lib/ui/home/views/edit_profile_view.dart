import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';
import 'package:unetpedia/widgets/generic_network_image.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/ui/authentication/cubit/cubit.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';

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
          listenWhen: (p, c) => p.genericStatus != c.genericStatus,
          listener: (context, state) {
            if (state.genericStatus == WidgetStatus.success) {
              context.read<GeneralCubit>().getUser(); // refresca usuario
              debugPrint("👀 getUser llamado");
              Navigator.pop(context);
            } else if (state.genericStatus == WidgetStatus.error) {
              showDialog(
                context: context,
                builder: (_) => GenericStatusDialog(
                  description: state.errorText,
                  isErrorDialog: true,
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                const _View(),
                if (state.genericStatus == WidgetStatus.loading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(child: LoadingIndicator()),
                    ),
                  ),
              ],
            );
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  File? _selectedImage;

  @override
  void initState() {
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<GeneralCubit>().state.user;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD9D9D9),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover)
                              : GenericNetworkImage(url: user?.photoUrl),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.edit, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FormInput(
                  labelText: "Nombre",
                  hintText: "Ingresa tu nombre",
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FormInput(
                  labelText: "Apellido",
                  hintText: "Ingresa tu apellido",
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
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
                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationCubit>().updateUserProfile(
                        name: _nameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        imageFile: _selectedImage,
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
