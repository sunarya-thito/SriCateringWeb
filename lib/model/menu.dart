class Paket {
  final String nama;
  final String? photo;
  final List<PilihanPaket> pilihan;
  final int baseHarga;

  const Paket({
    required this.nama,
    this.photo,
    required this.pilihan,
    required this.baseHarga,
  });

  Paket.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        photo = json['photo'],
        pilihan = [], // pilihan diisi nanti karena butuh fetch dari firestore
        baseHarga = json['baseHarga'];

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'photo': photo,
      'pilihan': pilihan.map((e) => e.toJson()).toList(),
      'baseHarga': baseHarga,
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
        makanan = []; // makanan diisi nanti karena butuh fetch dari firestore

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
  final String? photo;
  final int harga;

  const Makanan({
    required this.nama,
    this.photo,
    required this.harga,
  });

  Makanan.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        photo = json['photo'],
        harga = json['harga'];

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'photo': photo,
      'harga': harga,
    };
  }
}
