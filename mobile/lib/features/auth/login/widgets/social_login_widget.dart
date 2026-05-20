import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  Widget socialButton({
    required String text,
    required String iconPath,
  }) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xffECEEF0),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xff6B707A),
                  fontSize: 14.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Ou continue com',
                style: TextStyle(
                  color: Color(0xff9EA1A7),
                  fontSize: 12.27,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            socialButton(
              text: 'Google',
              iconPath: 'assets/icons/google.svg',
            ),
            const SizedBox(width: 12),
            socialButton(
              text: 'Apple',
              iconPath: 'assets/icons/apple.svg',
            ),
          ],
        ),
      ],
    );
  }
}