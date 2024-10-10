import 'package:flutter/material.dart';
import 'package:mid_term/database/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';
import 'package:mid_term/database/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormData extends StatefulWidget {
  const FormData({super.key});

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  int k = 0;
  bool dataIsAvailable = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 239, 231),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Product",
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 75, 19),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Form",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 209, 209, 210),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tên sản phẩm",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Giá",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Loại sản phẩm",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
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
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    await addProductButton();
                    if (k == 0 && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sản phẩm đã được thêm thành công'),
                          backgroundColor: Color.fromARGB(255, 144, 59, 255),
                        ),
                      );
                    }
                    // if (context.mounted) {
                    //   Navigator.of(context).pop();
                    // }
                  },
                  child: Text(
                    "Thêm",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addProductButton() async {
    final name = _nameController.text.trim();
    final image = _imageController.text.trim();
    final category = _categoryController.text.trim();
    final price = _priceController.text.trim();

    if (name.isEmpty || image.isEmpty || category.isEmpty || price.isEmpty) {
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
