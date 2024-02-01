import 'dart:io';

import 'package:first_chat_app/colors.dart';
import 'package:first_chat_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:first_chat_app/states_management/onboarding/onboarding_state.dart';
import 'package:first_chat_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/onboarding/logo.dart';
import '../../widgets/onboarding/profile_upload.dart';
import '../../widgets/shared/custom_text_field.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String _username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(context),
              Spacer(),
              ProfileUpload(),
              Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: CustomTextField(
                  hint: 'what\'s your name?',
                  height: 45,
                  onchanged: (val) {
                    _username = val;
                  },
                  inputAction: TextInputAction.done,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    final error = _checkInputs();
                    if (error.isNotEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                          error,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    await _connectSession();
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) => state is Loading
                      ? Center(child: CircularProgressIndicator())
                      : Container()),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  _connectSession() async {
    final profileImageState = context.read<ProfileImageCubit>().state;
    if (profileImageState is ImageLoadedState) {
      await context.read<OnboardingCubit>().connect(
            _username,
            File(profileImageState.imagePath),
          );
    }
  }

  String _checkInputs() {
    var error = '';

    if (_username.isEmpty) {
      error = 'Please enter your name';
    }

    if (context.read<ProfileImageCubit>().state == null) {
      error = error + '\n' + 'Please enter your name';
    }

    return error;
  }
}

_logo(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('chat',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      SizedBox(width: 8),
      Logo(),
      SizedBox(width: 8),
      Text('chat',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold)),
    ],
  );
}
