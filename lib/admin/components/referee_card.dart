import 'package:aookamao/enums/referral_types.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RefereeCard extends StatelessWidget {
  final String refereeName;
  final ReferalTypes referalType;
  final Timestamp referalDate;
  final String? referedByName;

  const RefereeCard({
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
          border: Border.all(color: AppColors.kPrimary),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 7.h),
          title: Text(refereeName),
          subtitle: Text(DateFormat('dd MMM,yyyy').format(referalDate.toDate())),
          trailing: SizedBox(
            width: 90.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                referalType == ReferalTypes.DirectReferal ?
                Icon(Icons.person,color: AppColors.kPrimary,) :
                Row(
                  children: [
                    Icon(Icons.people,color: AppColors.kPrimary,),
                    SizedBox(width: 5.w,),
                    Expanded(child: Text('By $referedByName'??'',overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
