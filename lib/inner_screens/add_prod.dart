import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_nija_web_admin/controllers/MenuController.dart';
import 'package:food_nija_web_admin/responsive.dart';
import 'package:food_nija_web_admin/services/global_method.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/buttons.dart';
import 'package:food_nija_web_admin/widgets/header.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/side_menu.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';
  final String id;
  final String resName;
  const UploadProductForm({Key? key, required this.id, required this.resName})
      : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Cake';
  late final TextEditingController _titleController,
      _pr,
      _priceController,
      _desController;
  int _groupValue = 1;
  bool _isLoading = false;
  Uint8List? _file;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _desController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _desController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    _desController.clear();
    setState(() {
      _file = null;
    });
  }

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    if (_file == null) {
      GlobalMethods.errorDialog(
          subtitle: 'Please pick up an image', context: context);
      return;
    }
    final _uuid = const Uuid().v4();
    try {
      setState(() {
        _isLoading = true;
      });

      Reference ref = _storage.ref().child('foodsImages').child(_uuid + '.jpg');

      UploadTask uploadTask = ref.putData(_file!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('foods').doc(_uuid).set({
        'resId': widget.id,
        'resName': widget.resName,
        'id': _uuid,
        'foodName': _titleController.text,
        'des': _desController.text,
        'price': _priceController.text,
        'imageUrl': downloadUrl.toString(),
        'createdAt': Timestamp.now(),
        'cat': _catValue,
        'start': 0,
      });
      _clearForm();
      Fluttertoast.showToast(
        msg: "Product uploaded succefully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } on FirebaseException catch (error) {
      GlobalMethods.errorDialog(subtitle: '${error.message}', context: context);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<MenuController>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Header(
                        fct: () {}, title: 'Add product', showTexField: false),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: size.width > 650 ? 650 : size.width,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextWidget(
                            text: 'Food Name*',
                            color: color,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey('Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Title';
                              }
                              return null;
                            },
                            decoration: inputDecoration,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextWidget(
                            text: 'Food Desciption*',
                            color: color,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _desController,
                            key: const ValueKey('des'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            decoration: inputDecoration,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: 'Price in \$*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          controller: _priceController,
                                          key: const ValueKey('Price \$'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missed';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]')),
                                          ],
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextWidget(
                                        text: 'Porduct category*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        color: _scaffoldColor,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: catDropDownWidget(color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Image to be picked code is here
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: size.width > 650
                                        ? 350
                                        : size.width * 0.45,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: _file == null
                                        ? dottedBorder(color: color)
                                        : SizedBox(
                                            height: 45.0,
                                            width: 45.0,
                                            child: AspectRatio(
                                              aspectRatio: 487 / 451,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  alignment: FractionalOffset
                                                      .topCenter,
                                                  image: MemoryImage(_file!),
                                                )),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _file = null;
                                            });
                                          },
                                          child: TextWidget(
                                            text: 'Clear',
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: TextWidget(
                                            text: 'Update image',
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonsWidget(
                                  onPressed: _clearForm,
                                  text: 'Clear form',
                                  icon: IconlyBold.danger,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  onPressed: () {
                                    _uploadForm();
                                  },
                                  text: 'Upload',
                                  icon: IconlyBold.upload,
                                  backgroundColor: Colors.blue,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _selectImage(context);
                    }),
                    child: TextWidget(
                      text: 'Choose an image',
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    );
  }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: [
          DropdownMenuItem<String>(
            child: Text('Cake'),
            value: 'Cake',
          ),
          DropdownMenuItem<String>(
            child: Text('Main Course'),
            value: 'Main Course',
          ),
          DropdownMenuItem<String>(
            child: Text('Appetizer'),
            value: 'Appetizer',
          ),
          DropdownMenuItem<String>(
            child: Text('Dessert'),
            value: 'Dessert',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('Select a Category'),
        value: _catValue,
      ),
    );
  }
}
