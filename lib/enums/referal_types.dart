enum ReferalTypes{
  DirectReferal,
  IndirectReferal,
}

String referalTypeToString(ReferalTypes referalType){
  switch(referalType){
    case ReferalTypes.DirectReferal:
      return 'Direct Referal';
    case ReferalTypes.IndirectReferal:
      return 'Indirect Referal';
    default:
      return '';
  }
}

ReferalTypes referalTypeFromString(String referalType){
  switch(referalType){
    case 'Direct Referal':
      return ReferalTypes.DirectReferal;
    case 'Indirect Referal':
      return ReferalTypes.IndirectReferal;
    default:
      return ReferalTypes.DirectReferal;
  }
}