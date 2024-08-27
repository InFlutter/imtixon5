import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // BlocBuilder uchun
import '../../bloc/recip_bloc.dart';
import '../../bloc/recip_event.dart';
import '../../bloc/recip_state.dart';
import '../../models/recip.dart';
import '../../utils/helpers.dart'; // Ensure the correct path to your Helpers

class ManageRecip extends StatefulWidget {
  final Recip? recip;

  ManageRecip({super.key, this.recip});

  @override
  State<ManageRecip> createState() => _ManageRecipState();
}

class _ManageRecipState extends State<ManageRecip> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final productsController = TextEditingController();
  File? imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.recip != null) {
      nameController.text = widget.recip!.recepName;
      descriptionController.text = widget.recip!.recepDescription;
      productsController.text = widget.recip!.recepProducts.join(', ');
    }
  }

  void uploadImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: imageSource);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.recip == null ? "Qo'shish" : "O'zgartirish"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nomi",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Tavsif",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: productsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mahsulotlar (vergul bilan ajrating)",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Rasm Tanlang",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    uploadImage(ImageSource.camera);
                  },
                  label: const Text("Kamera"),
                  icon: const Icon(Icons.camera),
                ),
                TextButton.icon(
                  onPressed: () {
                    uploadImage(ImageSource.gallery);
                  },
                  label: const Text("Galleriya"),
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
            if (imageFile != null)
              SizedBox(
                height: 200,
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            if (widget.recip != null && imageFile == null)
              SizedBox(
                height: 200,
                child: Image.network(
                  widget.recip!.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Bekor Qilish"),
        ),
        BlocConsumer<RecipBloc, RecipState>(
          listener: (context, state) {
            if (state is RecipLoadSuccess) {
              Navigator.pop(context); // close progress dialog
              Navigator.pop(context); // close manage dialog
            } else if (state is RecipLoadFailure) {
              Navigator.pop(context); // close progress dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Xato yuz berdi: ${state.error}"),
                ),
              );
            }
          },
          builder: (context, state) {
            return FilledButton(
              onPressed: () async {
                Helpers.showProgressDialog(context);

                final String recepName = nameController.text;
                final String recepDescription = descriptionController.text;
                final List<String> recepProducts = productsController.text.split(',').map((e) => e.trim()).toList();

                if (widget.recip == null) {
                  if (imageFile != null) {
                    context.read<RecipBloc>().add(AddRecip(
                      recepName: recepName,
                      recepDescription: recepDescription,
                      recepProducts: recepProducts,
                      imageFile: imageFile!,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Iltimos, rasm tanlang."),
                      ),
                    );
                  }
                } else {
                  context.read<RecipBloc>().add(EditRecip(
                    id: widget.recip!.id,
                    oldImageUrl: widget.recip!.imageUrl,
                    recepName: recepName,
                    imageFile: imageFile,
                    recepDescription: recepDescription,
                    recepProducts: recepProducts,
                  ));
                }
              },
              child: state is RecipLoadInProgress
                  ? const CircularProgressIndicator() // Show loading indicator while processing
                  : const Text("Saqlash"),
            );
          },
        ),
      ],
    );
  }
}
