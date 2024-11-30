import 'package:aookamao/admin/models/retailer_model.dart';
import 'package:aookamao/retailer/components/retailer_appbar.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../enums/subscription_status.dart';
import '../../../models/subscription_model.dart';
import 'controller/retailer_controller.dart';

class RetailerDetailsScreen extends StatelessWidget {
  final RetailerModel retailer;

  RetailerDetailsScreen({required this.retailer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RetailerAppBar(title: 'Retailers',),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Supplier Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Supplier Name
                    Text(
                      retailer.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 12),
                    //cnic number
                    _buildInfoRow(Icons.badge,  retailer.cnic_number),

                    // Email
                    _buildInfoRow(Icons.email, retailer.email),

                    // Registration Date with time
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Registered on: ${DateFormat('MMM dd,yyyy hh:mm').format(retailer.registered_at.toDate())}',
                    ),
                    // Referrals Count
                    _buildInfoRow(Icons.people, 'Referrals: '),
                    // Subscription date
                    if(retailer.subscription_status != SubscriptionStatus.none)
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Subscription Date: ${DateFormat('MMM dd,yyyy hh:mm').format(retailer.subscription_date.toDate())}',
                    ),

                    // Subscription Status
                    _buildInfoRow(
                      retailer.subscription_status == SubscriptionStatus.active ? Icons.check_circle : Icons.cancel,
                      'Subscription: ${subscriptionStatusToString(retailer.subscription_status)}',
                      color: retailer.subscription_status == SubscriptionStatus.active ? Colors.green : Colors.red,
                    ),


                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CNIC Images Section
              const Text(
                'CNIC Images',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildImageColumn('Front', retailer.cnic_front_image_url),
                  const SizedBox(width: 16),
                  _buildImageColumn('Back', retailer.cnic_back_image_url),
                ],
              ),
              const SizedBox(height: 50),

              // Approve Subscription Button
              if(retailer.subscription_status == SubscriptionStatus.pending)
              Center(
                child: PrimaryButton(
                  text: 'Approve Subscription',
                 onTap: ()=>_approveSubscription(),
                  width: 200.w,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build information rows with icons
  Widget _buildInfoRow(IconData icon, String text, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: color),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build image column
  Widget _buildImageColumn(String label, String imageUrl) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  // Function to handle subscription approval
  void _approveSubscription() {
    // Logic to approve subscription (e.g., API call)
    final _retailerController = Get.find<RetailerController>();
    Get.dialog(
      AlertDialog(
        title: const Text('Subscription'),
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 40),
        content: const Text('Do you want to approve this supplier subscription?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () =>_retailerController.approveRetailer(
              subdetail: SubscriptionModel(uid: retailer.uid,subscriptionStatus: SubscriptionStatus.active,subscriptionDate: Timestamp.now()),
            ),
            child: const Text('Approve', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
