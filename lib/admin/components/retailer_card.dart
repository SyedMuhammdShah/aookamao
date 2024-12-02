import 'package:aookamao/admin/models/retailer_model.dart';
import 'package:aookamao/enums/subscription_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../modules/retailers/retailer_details.dart';

class RetailerCard extends StatelessWidget {
  final RetailerModel retailer;

  RetailerCard({required this.retailer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ()=>Get.to(()=>RetailerDetailsScreen(retailer: retailer)),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // retailer name with icon
                Row(
                  children: [
                    Icon(Icons.store, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      retailer.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.grey),
                            SizedBox(width: 8),
                            SizedBox(
                              width: ScreenUtil().screenWidth * 0.32,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  retailer.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              retailer.subscription_status == SubscriptionStatus.active ? Icons.check_circle : Icons.cancel,
                              color: retailer.subscription_status == SubscriptionStatus.active ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Subscription: ${subscriptionStatusToString(retailer.subscription_status)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: retailer.subscription_status == SubscriptionStatus.active ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Registered on: ${DateFormat('yyyy-MM-dd').format(retailer.registered_at.toDate())}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
                      ],
                    ),
                  ],
                )

                  ],
                ),
          ),
        ),
      ),
    );
  }
}
