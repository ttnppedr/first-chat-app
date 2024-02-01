import 'dart:io';

import 'package:first_chat_app/colors.dart';
import 'package:first_chat_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:first_chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: 126,
      child: Material(
        color: isLightTheme(context) ? Color(0xFFF2F2F2) : Color(0xFF211E1E),
        borderRadius: BorderRadius.circular(126),
        child: InkWell(
          borderRadius: BorderRadius.circular(126),
          onTap: () async {
            await context.read<ProfileImageCubit>().getImage();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: BlocBuilder<ProfileImageCubit, ImageState>(
                    builder: (context, state) {
                  if (state is ImageLoadedState) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(126),
                      child: Image.file(
                        File(state.imagePath) as File,
                        width: 126,
                        height: 126,
                        fit: BoxFit.fill,
                      ),
                    );
                  }

                  return Icon(
                    Icons.person_outline_rounded,
                    size: 126,
                    color: isLightTheme(context) ? kIconLight : Colors.black,
                  );
                }),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.add_circle_rounded,
                    color: kPrimary,
                    size: 38,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
