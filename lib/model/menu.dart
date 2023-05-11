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

  @override
  int get hashCode => nama.hashCode ^ minimal.hashCode ^ maksimal.hashCode;
}

class Makanan {
  final String nama;
  final int harga;

  const Makanan({
    required this.nama,
    required this.harga,
  });

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
}
