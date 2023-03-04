// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/*
showDialog(
  context: context,
  builder: (context) => PhotoPickerDialog(),
).then((value) {
  if (value == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(value as String),
  ));
  setState(() {
    path = value;
  });
});
 */
class PhotoPickerDialog extends StatefulWidget {
  bool enableCamera;
  bool enableGalery;
  File? _image;
  String path;

  String labelPhotoPicker;
  String labelSubmit;
  String labelCancel;
  String labelOk;
  String labelChangePicture;

  PhotoPickerDialog({
    Key? key,
    this.enableCamera = true,
    this.enableGalery = true,
    this.path = "",
    this.labelPhotoPicker = 'Photo Picker',
    this.labelSubmit = 'Submit',
    this.labelCancel = 'Cancel',
    this.labelOk = 'Ok',
    this.labelChangePicture = 'Change Picture?',
  }) : super(key: key);

  @override
  State<PhotoPickerDialog> createState() => _PhotoPickerDialogState();
}

class _PhotoPickerDialogState extends State<PhotoPickerDialog> {
  Future pickImageGalery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        widget._image = imageTemp;
        widget.path = imageTemp.path;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to pick image : $e"),
      ));
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        widget._image = imageTemp;
        widget.path = imageTemp.path;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to pick image : $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      elevation: 0.0,
      content: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: [
                      Text(widget.labelPhotoPicker),
                      if (kDebugMode) Text('Path : ${widget.path}'),
                      widget._image != null
                          ? widget.path.toString().contains("http")
                              ? Container(margin: const EdgeInsets.only(top: 16), child: Image.network(widget.path))
                              : Container(margin: const EdgeInsets.only(top: 16), child: Image.file(widget._image!))
                          : Container(),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.enableCamera
                                ? InkWell(
                                    onTap: () {
                                      widget.path.isEmpty ? pickImageCamera() : confirmChangePhoto(1);
                                    },
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : Container(),
                            widget.enableCamera && widget.enableGalery ? const SizedBox(width: 16) : Container(),
                            widget.enableGalery
                                ? InkWell(
                                    onTap: () {
                                      widget.path.isEmpty ? pickImageGalery() : confirmChangePhoto(2);
                                    },
                                    child: Icon(
                                      Icons.photo_library_rounded,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : Container(),
                            const SizedBox(width: 16),
                            if (widget.path.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(left: 16.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context, widget.path);
                                  },
                                  child: Text(widget.labelSubmit),
                                ),
                              ),
                            Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context, null);
                                },
                                child: Text(widget.labelCancel),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  confirmChangePhoto(int type) {
    showDialog(
      context: context,
      builder: (context) => _ConfirmDialog(
        labelChangePicture: widget.labelChangePicture,
        labelOk: widget.labelOk,
        labelCancel: widget.labelCancel,
      ),
    ).then((value) {
      if (value == null) return;
      if (value == 1) {
        if (type == 1) {
          pickImageCamera();
        } else if (type == 2) {
          pickImageGalery();
        }
      }
    });
  }
}

class _ConfirmDialog extends StatelessWidget {
  String labelChangePicture;
  String labelOk;
  String labelCancel;

  _ConfirmDialog({
    Key? key,
    required this.labelChangePicture,
    required this.labelOk,
    required this.labelCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      elevation: 0.0,
      content: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        Text(labelChangePicture),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 0);
                                },
                                child: Text(labelCancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 1);
                                },
                                child: Text(labelOk),
                              ),
                            ],
                          ),
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
    );
  }
}
