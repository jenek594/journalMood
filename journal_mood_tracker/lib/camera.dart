// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Imagecontainer extends StatefulWidget {
  const Imagecontainer({super.key});

  @override
  State<Imagecontainer> createState() => _ImagecontainerState();
}

class _ImagecontainerState extends State<Imagecontainer> {

  XFile? _mediaFile;

  void _setImageFileListFromFile(XFile value) {
    _mediaFile = value;
  }

  dynamic _pickImageError;

  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();


  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool isMedia = false,
    }) async {
    if (context.mounted) {
     if (isMedia) {
          try {
            final XFile pickedFile;
            final XFile? media = await _picker.pickMedia(
              maxWidth: 200,
              maxHeight: 200,
              imageQuality: 100,
            );
            if (media != null) {
              pickedFile = media;
              setState(() {
                _mediaFile = pickedFile;
              });
            }
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        } else {
            try {
              final XFile? pickedFile = await _picker.pickImage(
                source: source,
                maxWidth: 200,
                maxHeight: 200,
                imageQuality: 100,
              );
              setState(() {
                _setImageFileListFromFile(pickedFile!);
              });
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
        }
      }
    }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }



  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFile != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: 
            Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_mediaFile!.path)
                  : Image.file(
                        File(_mediaFile!.path),
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                              child:
                                  Text('This image type is not supported'));
                        },
                      )
            )
        );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file!);
          } else {
            _mediaFile = response.file;
          }
        });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
           if(_mediaFile != null)
            Align(
            alignment: Alignment.centerLeft,
             child: Container(
              width: MediaQuery.sizeOf(context).width / 2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 218, 218),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromARGB(255, 148, 148, 148),
                  width: 0.5,
                  style: BorderStyle.solid
                )
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 200,
              padding: EdgeInsets.all(10),
              child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                  ? FutureBuilder<void>(
                      future: retrieveLostData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Text(
                              'You have not yet picked an image.',
                              textAlign: TextAlign.center,
                            );
                          case ConnectionState.done:
                            return _handlePreview();
                          case ConnectionState.active:
                            if (snapshot.hasError) {
                              return Text(
                                'Pick image/video error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return const Text(
                                'You have not yet picked an image.',
                                textAlign: TextAlign.center,
                              );
                            }
                        }
                      },
                    )
                  : _handlePreview(),
                       ),
           ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Semantics(
                  label: 'image_picker_example_from_gallery',
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.gallery, context: context);
                    },
                    label: Text('Из галереи'),
                    icon: const Icon(Icons.photo),
                  ),
                ),
                if (_picker.supportsImageSource(ImageSource.camera))
                FilledButton.tonalIcon(
                  onPressed: (){
                    _onImageButtonPressed(ImageSource.camera, context: context);
                  }, 
                  icon: const Icon(Icons.camera_alt), 
                  label: Text('Сделать снимок')
                )
              ],
            ),
          )
        ],
      );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
