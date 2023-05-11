import 'package:flutter/foundation.dart';

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

  String? validasi() {
    if (nama.isEmpty) return 'Nama Paket tidak boleh kosong';
    if (baseHarga < 0) return 'Harga Paket tidak boleh negatif';
    for (var p in pilihan) {
      var err = p.validasi();
      if (err != null) return err;
    }
    return null;
  }

  Paket copyWith(String id) {
    return Paket(
      id: id,
      nama: nama,
      pilihan: pilihan,
      baseHarga: baseHarga,
      deskripsi: deskripsi,
    );
  }

  Paket.fromJson(this.id, Map<String, dynamic> json)
      : nama = json['nama'],
        pilihan = json['pilihan']
                ?.map((e) => PilihanPaket.fromJson(e))
                .cast<PilihanPaket>()
                .toList() ??
            [],
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Paket &&
        other.id == id &&
        other.nama == nama &&
        listEquals(other.pilihan, pilihan) &&
        other.baseHarga == baseHarga &&
        other.deskripsi == deskripsi;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        pilihan.hashCode ^
        baseHarga.hashCode ^
        deskripsi.hashCode;
  }

  @override
  String toString() {
    return 'Paket(id: $id, nama: $nama, pilihan: $pilihan, baseHarga: $baseHarga, deskripsi: $deskripsi)';
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

  String? validasi() {
    if (nama.isEmpty) return 'Nama Pilihan tidak boleh kosong';
    if (minimal < 0) return 'Minimal tidak boleh negatif';
    if (maksimal < 0) return 'Maksimal tidak boleh negatif';
    if (maksimal < minimal) {
      return 'Maksimal tidak boleh lebih kecil dari minimal';
    }
    if (makanan.isEmpty) return 'Pilihan harus memiliki makanan';
    for (var m in makanan) {
      var err = m.validasi();
      if (err != null) return err;
    }
    return null;
  }

  // buat copyWith
  PilihanPaket copyWith({
    String? nama,
    int? minimal,
    int? maksimal,
    List<Makanan>? makanan,
  }) {
    return PilihanPaket(
      nama: nama ?? this.nama,
      minimal: minimal ?? this.minimal,
      maksimal: maksimal ?? this.maksimal,
      makanan: makanan ?? this.makanan,
    );
  }

  // overload ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PilihanPaket &&
        other.nama == nama &&
        other.minimal == minimal &&
        other.maksimal == maksimal &&
        listEquals(other.makanan, makanan);
  }

  PilihanPaket.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        minimal = json['minimal'],
        maksimal = json['maksimal'],
        makanan = json['makanan']
                ?.map((e) => Makanan.fromJson(e))
                .toList()
                .cast<Makanan>() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'minimal': minimal,
      'maksimal': maksimal,
      'makanan': makanan.map((e) => e.toJson()).toList(),
    };
  }

  @override
  int get hashCode => nama.hashCode ^ minimal.hashCode ^ maksimal.hashCode;

  @override
  String toString() {
    return 'PilihanPaket(nama: $nama, minimal: $minimal, maksimal: $maksimal, makanan: $makanan)';
  }
}

class Makanan {
  final String nama;
  final int harga;

  const Makanan({
    required this.nama,
    required this.harga,
  });

  String? validasi() {
    if (nama.isEmpty) return 'Nama Makanan tidak boleh kosong';
    if (harga < 0) return 'Harga tidak boleh negatif';
    return null;
  }

  Makanan copyWith({
    String? nama,
    int? harga,
  }) {
    return Makanan(
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
    );
  }

  Makanan.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        harga = json['harga'];

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Makanan && other.nama == nama && other.harga == harga;
  }

  @override
  int get hashCode => nama.hashCode ^ harga.hashCode;

  @override
  String toString() => 'Makanan(nama: $nama, harga: $harga)';
}
