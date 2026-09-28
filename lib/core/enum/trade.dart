enum Trade {
  DIRECT('DIRECT', '직거래'),
  DELIVERY('DELIVERY', '택배'),
  BOTH('BOTH', '둘 다');

  final String v;
  final String l;

  const new(this.v, this.l);

  static Trade? fromCode(String code) {
    return Trade.values.where((element) => element.v == code).firstOrNull;
  }
}
