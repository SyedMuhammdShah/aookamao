import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/models/user_model.dart';
import 'package:aookamao/models/wallet_model.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../enums/transaction_status.dart';
import '../../../../models/transaction_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/transaction_service.dart';

class TransactionController extends GetxController{
  final _authService = Get.find<AuthService>();
  final _transactionService = Get.find<TransactionService>();
  final _firestore = FirebaseFirestore.instance;
  RxList<TransactionModel> transactionsList = <TransactionModel>[].obs;
  Rx<UserModel?> userDetails = Rx<UserModel?>(null);
  Rx<WalletModel?> userWallet = Rx<WalletModel?>(null);
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    transactionsList.bindStream(_transactionService.getTransactions());
    super.onInit();
  }

  Future<void> getUserDetails({required String userId}) async {
    try{
      final user = await _firestore.collection(Constants.usersCollection).doc(userId).get();
      userDetails.value = UserModel.fromFirestore(user);

      final wallet = await _firestore.collection(Constants.walletCollection).doc(userId).get();
      userWallet.value = WalletModel.fromMap(wallet.data() ?? {});

    }
    catch(e){
      print(e);
    }
  }

  Future<void> updateTransactionStatus({required TransactionModel transaction}) async {
    try{
      isLoading.value = true;
      await _transactionService.updateTransaction(transaction);
      showSuccessSnackbar('Transaction ${transactionStatusToString(transaction.transactionStatus)} successfully');
      isLoading.value = false;
    }
    catch(e){
      isLoading.value = false;
      showErrorSnackbar(e.toString());
      print(e);
    }
  }

}