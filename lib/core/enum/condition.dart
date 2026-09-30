enum Condition {
  SS('SS', '미개봉 새상품'),
  M('M', 'Mint - 완벽한 상태'),
  NM('NM', 'Near Mint - 거의 새것'),
  EX('EX', 'Excellent - 약간의 사용감'),
  VG_P('VG+', 'Very Good+ - 양호'),
  VG('VG', 'Very Good - 사용감 있음'),
  G('G', 'Good - 재생 가능');

  final String v;
  final String l;

  const new(this.v, this.l);

  static List<Condition> getFilterList() {
    return [.M, .NM, .VG_P, .VG, .G];
  }

  static String getFilterLabel(Condition con) {
    return con == .M ? "Mint" : con.v;
  }

  static Condition? fromCode(String code) {
    return Condition.values.where((element) => element.v == code).firstOrNull;
  }
}
