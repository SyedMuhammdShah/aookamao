import 'package:aookamao/enums/referral_types.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReferalCard extends StatelessWidget {
  final String refereeName;
  final ReferalTypes referalType;
  final Timestamp referalDate;
  final String? referedByName;

  const ReferalCard({
    required this.refereeName,
    required this.referalType,
    required this.referalDate,
    this.referedByName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 100,
      margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(10),
       border: Border.all(color: AppColors.kSecondary.withOpacity(0.2)),
       color: Colors.white,
       boxShadow: [
         BoxShadow(
           color: AppColors.kSecondary.withOpacity(0.1),
           spreadRadius: 1,
           blurRadius: 1,
           offset: Offset(0, 1), // changes position of shadow
         ),
       ],
     ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 7.h),
        title: Text(refereeName,style: AppTypography.kSemiBold12.copyWith(color: AppColors.kSecondary),),
        subtitle: Text(DateFormat('dd MMM,yyyy').format(referalDate.toDate())),
        trailing: SizedBox(
          width: 0.2.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              referalType == ReferalTypes.DirectReferal
                  ? Icon(Icons.person,) :
              Row(
                children: [
                  Icon(Icons.people,),
                  Text(referedByName??''),
                ],
              ),
              Text(referalTypeToString(referalType)),
            ],
          ),
        ),
      )
    );
  }
}
