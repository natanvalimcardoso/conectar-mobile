import 'package:flutter/material.dart';

import 'user_info_section_widget.dart';
import 'user_name_section_widget.dart';
import 'user_password_section_widget.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserInfoSectionWidget(),
          SizedBox(height: 16),
          UserNameSectionWidget(),
          SizedBox(height: 16),
          UserPasswordSectionWidget(),
        ],
      ),
    );
  }
} 