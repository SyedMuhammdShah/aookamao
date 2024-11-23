import 'package:aookamao/enums/reward_status.dart';
import 'package:aookamao/enums/rewarded_to.dart';
import 'package:aookamao/models/reward_model.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class RewardCard extends StatelessWidget {
  final Rx<RewardModel> reward;
  const RewardCard({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reward Header (User Info + Status)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.value.rewardUserName ?? "Unknown User",
                        style: AppTypography.kSemiBold16
                      ),
                      const SizedBox(height: 4),
                      _buildRewardedToChip(reward.value.rewardedTo!),
                    ],
                  ),
                  _buildRewardStatusChip(reward.value.rewardStatus!),
                ],
              ),
              const SizedBox(height: 16),

              // Reward Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Reward Amount:",
                    style:AppTypography.kMedium14.copyWith(color: Colors.grey),
                  ),
                  Text(
                    "Rs.${reward.value.rewardAmount?.toStringAsFixed(2) ?? '0.00'}",
                    style: AppTypography.kSemiBold14,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Order ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Order ID:",
                    style:AppTypography.kMedium14.copyWith(color: Colors.grey),
                  ),
                  Text(
                    reward.value.orderId ?? "N/A",
                    style: AppTypography.kSemiBold14,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Reward Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Reward Date:",
                    style: AppTypography.kMedium14.copyWith(color: Colors.grey),
                  ),
                  Text(DateFormat('MMM dd,yyyy').format(reward.value.rewardDate!.toDate()),
                    style: AppTypography.kSemiBold14,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildRewardStatusChip(RewardStatus status) {
  Color statusColor;
  String statusText;

  switch (status) {
    case RewardStatus.pending:
      statusColor = Colors.orange;
      statusText = "Pending";
      break;
    case RewardStatus.approved:
      statusColor = Colors.green;
      statusText = "Approved";
      break;
      case RewardStatus.rejected:
      statusColor = Colors.red;
      statusText = "Rejected";
      break;
    default:
      statusColor = Colors.grey;
      statusText = "Unknown";
  }

  return Chip(
    label: Text(
      statusText,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: statusColor,
    side: const BorderSide(color: Colors.transparent),
  );
}

Widget _buildRewardedToChip(RewardedTo rewardedTo) {

  String statusText;

  switch (rewardedTo) {
    case RewardedTo.Customer:

      statusText = "Customer";
      break;
    case RewardedTo.REFFERAL_USER:

      statusText = "Referral User";
      break;
    case RewardedTo.RETAILER:

      statusText = "Retailer";
      break;
    default:
      statusText = "Unknown";
  }

  return Text(
    statusText,
    style: AppTypography.kSemiBold12.copyWith(),
  );
}