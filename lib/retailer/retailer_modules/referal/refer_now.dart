import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../admin/components/adminAppBar.dart';

class ReferNow extends StatelessWidget {
  const ReferNow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer Now',style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 0.02.sh,
            ),
            //referal code
            Row(
              children: [
                SizedBox(
                  width: 0.05.sw,
                ),
                Text('Referal Code:',style: AppTypography.kBold20,),
              ],
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            //referal code
            Container(
              width: 0.9.sw,
              height: 0.08.sh,
              padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
        
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('A123456',style: AppTypography.kMedium16,),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.copy),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            // qr code
            Container(
              width: 0.9.sw,
              height: 0.32.sh,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Scan QR Code',style: AppTypography.kSemiBold16,),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  QrImageView(
                    data: 'A123456',
                    version: QrVersions.auto,
                    size: 0.5.sw,
                    padding: EdgeInsets.all(0.02.sw),
                  ),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            SvgPicture.asset('assets/icons/share-code.svg',height: 0.32.sh,),
            SizedBox(
              height: 0.02.sh,
            ),
            Text("Share Your Referal Code",style: AppTypography.kMedium16.copyWith(color: Colors.grey),),
            SizedBox(
              height: 0.01.sh,
            ),
            //share referal code to social media
          ],
        ),
      )
    );
  }
}
