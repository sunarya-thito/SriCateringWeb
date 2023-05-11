class Paket {
  final String id;
  final String nama;
  final List<PilihanPaket> pilihan;
  final int baseHarga;
  final String deskripsi;

  const Paket({
    required this.id,
    required this.nama,
    required this.pilihan,
    required this.baseHarga,
    required this.deskripsi,
  });

  Paket copyWith(String id) {
    return Paket(
      id: id,
      nama: nama,
      pilihan: pilihan,
      baseHarga: baseHarga,
    );
  }

  Paket.fromJson(this.id, Map<String, dynamic> json)
      : nama = json['nama'],
        pilihan = (json['pilihan'] as List<dynamic>)
            .map((e) => PilihanPaket.fromJson(e))
            .toList(),
        baseHarga = json['baseHarga'],
        deskripsi = json['deskripsi'];

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'pilihan': pilihan.map((e) => e.toJson()).toList(),
      'baseHarga': baseHarga,
      'deskripsi': deskripsi,
    };
  }
}

class PilihanPaket {
  final String nama;
  final int minimal;
  final int maksimal;
  final List<Makanan> makanan;

  const PilihanPaket({
    required this.nama,
    required this.minimal,
    required this.maksimal,
    required this.makanan,
  });

  PilihanPaket.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        minimal = json['minimal'],
        maksimal = json['maksimal'],
        makanan = (json['makanan'] as List<dynamic>)
            .map((e) => Makanan.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'minimal': minimal,
      'maksimal': maksimal,
    };
  }
}

class Makanan {
  final String nama;
  final int harga;

  const Makanan({
    required this.nama,
    required this.harga,
  });

  Makanan.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        harga = json['harga'];

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
    };
  }
}
