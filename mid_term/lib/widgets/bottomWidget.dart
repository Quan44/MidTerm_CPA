import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mid_term/database/product.dart';
import 'package:mid_term/database/services.dart';

int k = 0;
bool dataIsAvailable = false;

final TextEditingController _nameController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final TextEditingController _imageController = TextEditingController();
final TextEditingController _categoryController = TextEditingController();
final TextEditingController _priceController = TextEditingController();

class BottomUpSheet {
  final String? name;
  final String? id;
  final String? image;
  final String? category;
  final String? price;
  final BuildContext context;
  final bool? dataIsAvailable;

  BottomUpSheet({
    this.name,
    this.id,
    this.image,
    this.category,
    this.price,
    this.dataIsAvailable,
    required this.context,
  });

  void productDetailsForm() async {
    _nameController.clear();
    _descriptionController.clear();
    _imageController.clear();
    _categoryController.clear();
    _priceController.clear();

    if (dataIsAvailable != true) {
      _nameController.text = name!;
      _imageController.text = image!;
      _categoryController.text = category!;
      _priceController.text = price!;
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
      ),
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nhập tên sản phẩm'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _imageController,
              decoration:
                  const InputDecoration(hintText: 'Nhập link ảnh sản phẩm'),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String? imagePath = await _uploadImage();
                if (imagePath != null && context.mounted) {
                  _imageController.text = imagePath;
                }
              },
              child: const Text('Tải ảnh lên'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _categoryController,
              decoration:
                  const InputDecoration(hintText: 'Nhập danh mục sản phẩm'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(hintText: 'Nhập giá sản phẩm'),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await addProductButton();
                    if (k == 0 && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sản phẩm đã được thêm thành công'),
                          backgroundColor: Color.fromARGB(255, 144, 59, 255),
                        ),
                      );
                    }
                  } else {
                    await updateProduct(Product(
                      id: id!,
                      name: _nameController.text,
                      img: _imageController.text,
                      category: _categoryController.text,
                      price: int.parse(_priceController.text),
                    ));
                  }

                  _nameController.clear();
                  _descriptionController.clear();
                  _imageController.clear();
                  _categoryController.clear();
                  _priceController.clear();

                  // Đóng bottom sheet
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Cập nhật sản phẩm'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addProductButton() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final image = _imageController.text.trim();
    final category = _categoryController.text.trim();
    final price = _priceController.text.trim();

    if (name.isEmpty ||
        description.isEmpty ||
        image.isEmpty ||
        category.isEmpty ||
        price.isEmpty) {
      k = 1;
      return;
    }
    final product = Product(
      id: Random().nextInt(1000000).toString(),
      name: name,
      img: image,
      category: category,
      price: int.parse(price),
    );
    addProduct(product);
  }

  Future<String?> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      try {
        UploadTask uploadTask = storageReference.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print("Lỗi khi tải ảnh lên: $e");
        return null;
      }
    }
    return null;
  }
}