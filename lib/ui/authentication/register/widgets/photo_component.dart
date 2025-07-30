import 'package:flutter/material.dart';
import 'package:unetpedia/models/generic/photo_model.dart';
import 'package:unetpedia/widgets/generic_network_image.dart';
import 'package:unetpedia/widgets/modals/upload_modal.dart';

class PhotoComponent extends StatelessWidget {
  const PhotoComponent({
    super.key,
    this.path,
    required this.imageSelected,
    this.onGetImage,
  });

  final String? path;
  final PhotoModel? imageSelected;
  final Function(PhotoModel)? onGetImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: (onGetImage != null)
            ? () {
                FocusScope.of(context).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();

                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  builder: (_) => UploadModal(onGetImage: onGetImage!),
                );
              }
            : null,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDCDAD8),
                border: Border.all(color: const Color(0xFF828282)),
              ),
              child: (imageSelected != null)
                  ? ClipOval(
                      child: Image.file(imageSelected!.file, fit: BoxFit.cover),
                    )
                  : (path != null)
                  ? GenericNetworkImage(url: path, borderRadius: 100)
                  : const Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: Color(0xFF828282),
                    ),
            ),
            (onGetImage != null)
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF282828),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
