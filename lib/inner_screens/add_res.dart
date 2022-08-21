import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_nija_web_admin/controllers/MenuController.dart';
import 'package:food_nija_web_admin/responsive.dart';
import 'package:food_nija_web_admin/screens/loading_manager.dart';
import 'package:food_nija_web_admin/services/global_method.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/buttons.dart';
import 'package:food_nija_web_admin/widgets/header.dart';
import 'package:food_nija_web_admin/widgets/side_menu.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadrestaurantForm extends StatefulWidget {
  static const routeName = '/UploadrestaurantForm';

  const UploadrestaurantForm({Key? key}) : super(key: key);

  @override
  _UploadrestaurantFormState createState() => _UploadrestaurantFormState();
}

class _UploadrestaurantFormState extends State<UploadrestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Vegetables';
  late final TextEditingController _titleController,
      _kmController,
      _priceController,
      _desController;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  bool _isLoading = false;
  Uint8List? _filelogo;
  Uint8List? _fileView;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _desController = TextEditingController();
    _kmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _desController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    if (_fileView == null || _filelogo == null) {
      GlobalMethods.errorDialog(
          subtitle: 'Please pick up an image', context: context);
      return;
    }
    final _uuid1 = const Uuid().v4();

    try {
      setState(() {
        _isLoading = true;
      });

      Reference ref1 =
          _storage.ref().child('restaurantsImages').child(_uuid1 + '.jpg');

      UploadTask uploadTask1 = ref1.putData(_filelogo!);

      Reference ref2 =
          _storage.ref().child('ViewrestaurantsImages').child(_uuid1 + '.jpg');

      UploadTask uploadTask2 = ref2.putData(_fileView!);

      TaskSnapshot snapshot1 = await uploadTask1;
      String downloadUrl1 = await snapshot1.ref.getDownloadURL();

      TaskSnapshot snapshot2 = await uploadTask1;
      String downloadUrl2 = await snapshot1.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(_uuid1)
          .set({
        'id': _uuid1,
        'resName': _titleController.text.toLowerCase(),
        'des': _desController.text.toLowerCase(),
        'time': _priceController.text,
        'km': _kmController.text,
        'imageUrl': downloadUrl1.toString(),
        'viewUrl': downloadUrl2.toString(),
        'createdAt': Timestamp.now(),
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

  void _clearForm() {
    _priceController.clear();
    _titleController.clear();
    _desController.clear();
    _kmController.clear();
    setState(() {
      _filelogo = null;
      _fileView = null;
    });
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
            child: LoadingManager(
              isLoading: _isLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Header(
                          fct: () {
                            context
                                .read<MenuController>()
                                .controlAddProductsMenu();
                          },
                          title: 'Add product',
                          showTexField: false),
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
                              text: 'Restaurant Name*',
                              color: color,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _titleController,
                              key: const ValueKey('Restaurant'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Restaurant Name';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextWidget(
                              text: 'introduce about restaurant*',
                              color: color,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _desController,
                              key: const ValueKey('Description'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Description';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: 'Time*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextFormField(
                                                controller: _priceController,
                                                key: const ValueKey('Time \$'),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Time is missed';
                                                  }
                                                  return null;
                                                },
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]')),
                                                ],
                                                decoration: inputDecoration,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            TextWidget(
                                              text: 'Mins',
                                              color: color,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        TextWidget(
                                          text: 'Km*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextFormField(
                                                controller: _kmController,
                                                key: const ValueKey('Km'),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'kM is missed';
                                                  }
                                                  return null;
                                                },
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]')),
                                                ],
                                                decoration: inputDecoration,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            TextWidget(
                                              text: 'km',
                                              color: color,
                                            ),
                                          ],
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
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: _filelogo == null
                                          ? dottedBorderLogo(color: color)
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
                                                    image:
                                                        MemoryImage(_filelogo!),
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
                                              _filelogo = null;
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
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 82,
                                  child: TextWidget(
                                    text: 'Add a view of the restaurans',
                                    color: color,
                                    isTitle: true,
                                  ),
                                ),
                                Spacer(),
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
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: _fileView == null
                                          ? dottedBorderView(color: color)
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
                                                    image:
                                                        MemoryImage(_fileView!),
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
                                              _fileView = null;
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
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectImageView(BuildContext parentContext) async {
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
                    _fileView = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _fileView = file;
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

  _selectImageLogo(BuildContext parentContext) async {
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
                  Uint8List file1 = await pickImage(ImageSource.camera);
                  setState(() {
                    _filelogo = file1;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file1 = await pickImage(ImageSource.gallery);
                  setState(() {
                    _filelogo = file1;
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

  Widget dottedBorderView({
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
                      _selectImageView(context);
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

  Widget dottedBorderLogo({
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
                      _selectImageLogo(context);
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
}
