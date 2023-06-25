import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils.dart';

import '../controller/auth_controller.dart';

class UpdateUserProfileView extends ConsumerStatefulWidget {
  const UpdateUserProfileView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UpdateUserProfileView> createState() =>
      _UpdateUserProfileViewState();
}

class _UpdateUserProfileViewState extends ConsumerState<UpdateUserProfileView> {
  File? _image;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_nameController.text.isEmpty || _image == null) {
      showSnackbar(context, 'Please pick an Image & enter your Name');
      return;
    }

    ref.read(authControllerProvider.notifier).createOrUpdateUser(
          context,
          widget.userId,
          _nameController.text,
          _image!.path,
          ref,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    enableFeedback: true,
                    onTap: () async {
                      final pickedImage = await pickImage();
                      if (pickedImage != null) {
                        setState(() {
                          _image = pickedImage;
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.deepPurpleAccent,
                          child: CircleAvatar(
                            radius: 52,
                            backgroundImage: _image == null
                                ? const AssetImage('assets/images/logo.png')
                                    as ImageProvider<Object>
                                : FileImage(
                                    File(_image!.path),
                                  ),
                          ),
                        ),
                        const Positioned(
                          bottom: 2,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextFormField(
                  autocorrect: true,
                  enableSuggestions: true,
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minWidth: double.infinity,
                  height: 60,
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onPressed: isLoading ? () {} : _submitData,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
