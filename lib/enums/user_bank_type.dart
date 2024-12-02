enum UserBankType{
  EasyPaisa,
  JazzCash,
  SadaPay,
  Nayapay,
  MeezanBank,
  BankAlHabib,
  BankIslami,
  AlfalahBank,
  FaysalBank,
  HBL,
  MCB,
  UBL,
  AskariBank,
  BankAlfalah,
  BankIslamiPakistan,
  DubaiIslamicBank
}

UserBankType? stringToUserBankType(String userBankType) {
  switch (userBankType) {
    case 'EasyPaisa':
      return UserBankType.EasyPaisa;
    case 'JazzCash':
      return UserBankType.JazzCash;
    case 'Meezan Bank':
      return UserBankType.MeezanBank;
    case 'Bank Al Habib':
      return UserBankType.BankAlHabib;
    case 'Bank Islami':
      return UserBankType.BankIslami;
    case 'Alfalah Bank':
      return UserBankType.AlfalahBank;
    case 'Faysal Bank':
      return UserBankType.FaysalBank;
    case 'HBL':
      return UserBankType.HBL;
    case 'MCB':
      return UserBankType.MCB;
    case 'UBL':
      return UserBankType.UBL;
    case 'Askari Bank':
      return UserBankType.AskariBank;
    case 'Bank Alfalah':
      return UserBankType.BankAlfalah;
    case 'Bank Islami Pakistan':
      return UserBankType.BankIslamiPakistan;
    case 'Dubai Islamic Bank':
      return UserBankType.DubaiIslamicBank;
      case 'SadaPay':
        return UserBankType.SadaPay;
      case 'NayaPay':
        return UserBankType.Nayapay;
    default:
      return null;
  }
}

String? userBankTypeToString(UserBankType? userBankType) {
  switch (userBankType) {
    case UserBankType.EasyPaisa:
      return 'EasyPaisa';
    case UserBankType.JazzCash:
      return 'JazzCash';
    case UserBankType.MeezanBank:
      return 'Meezan Bank';
    case UserBankType.BankAlHabib:
      return 'Bank Al Habib';
    case UserBankType.BankIslami:
      return 'Bank Islami';
    case UserBankType.AlfalahBank:
      return 'Alfalah Bank';
    case UserBankType.FaysalBank:
      return 'Faysal Bank';
    case UserBankType.HBL:
      return 'HBL';
    case UserBankType.MCB:
      return 'MCB';
    case UserBankType.UBL:
      return 'UBL';
    case UserBankType.AskariBank:
      return 'Askari Bank';
    case UserBankType.BankAlfalah:
      return 'Bank Alfalah';
    case UserBankType.BankIslamiPakistan:
      return 'Bank Islami Pakistan';
    case UserBankType.DubaiIslamicBank:
      return 'Dubai Islamic Bank';
      case UserBankType.SadaPay:
        return 'SadaPay';
      case UserBankType.Nayapay:
        return 'NayaPay';
    default:
      return 'N/A';
  }
}