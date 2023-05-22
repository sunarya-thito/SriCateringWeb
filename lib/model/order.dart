import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

enum OrderStatus {
  pending('Pending'),
  accepted('Diambil'),
  rejected('Ditolak'),
  delivered('Diantar'),
  canceled('Dibatalkan');

  final String displayName;
  const OrderStatus(this.displayName);
}

class Order {
  final String username;
  final String email;
  final String photoUrl;
  final DateTime tanggal;
  final String alamat;
  final String catatan;
  final OrderInfo orderInfo;
  final OrderStatus status;

  // json (de)serialization
  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'photoUrl': photoUrl,
        'tanggal': tanggal.toIso8601String(),
        'alamat': alamat,
        'orderInfo': orderInfo.toJson(),
        'catatan': catatan ?? '',
        'status': describeEnum(status),
      };

  Order.fromJson(Map<String, dynamic> json)
      : tanggal = DateTime.parse(json['tanggal']),
        alamat = json['alamat'],
        catatan = json['catatan'],
        username = json['username'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        status = OrderStatus.values.firstWhereOrNull(
              (e) => describeEnum(e) == (json['status'] ?? 'pending'),
            ) ??
            OrderStatus.pending,
        orderInfo = OrderInfo.fromJson(json['orderInfo']);

  // equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.tanggal == tanggal &&
        other.alamat == alamat &&
        other.catatan == catatan &&
        other.status == status &&
        other.orderInfo == orderInfo;
  }

  @override
  int get hashCode {
    return tanggal.hashCode ^
        alamat.hashCode ^
        catatan.hashCode ^
        status.hashCode ^
        orderInfo.hashCode;
  }

  // constructor
  const Order({
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.tanggal,
    required this.alamat,
    required this.catatan,
    required this.orderInfo,
    required this.status,
  });
}

class OrderInfo {
  final OrderPaket paket;
  final int jumlah;

  // json (de)serialization
  Map<String, dynamic> toJson() => {
        'paket': paket.toJson(),
        'jumlah': jumlah,
      };

  OrderInfo.fromJson(Map<String, dynamic> json)
      : paket = OrderPaket.fromJson(json['paket']),
        jumlah = json['jumlah'];

  // equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderInfo && other.paket == paket && other.jumlah == jumlah;
  }

  @override
  int get hashCode => paket.hashCode ^ jumlah.hashCode;

  // constructor
  const OrderInfo({
    required this.paket,
    required this.jumlah,
  });
}

class OrderPaket {
  final String paketId;
  final String nama;
  final int baseHarga;
  final String deskripsi;
  final List<OrderPilihanPaket> pilihan;

  // json (de)serialization
  Map<String, dynamic> toJson() => {
        'paketId': paketId,
        'nama': nama,
        'baseHarga': baseHarga,
        'deskripsi': deskripsi,
        'pilihan': pilihan.map((e) => e.toJson()).toList(),
      };

  OrderPaket.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        paketId = json['paketId'],
        baseHarga = json['baseHarga'],
        deskripsi = json['deskripsi'],
        pilihan = json['pilihan']
                ?.map((e) => OrderPilihanPaket.fromJson(e))
                .cast<OrderPilihanPaket>()
                .toList() ??
            [];

  const OrderPaket({
    required this.nama,
    required this.paketId,
    required this.baseHarga,
    required this.deskripsi,
    required this.pilihan,
  });

  // equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderPaket &&
        other.nama == nama &&
        other.baseHarga == baseHarga &&
        other.deskripsi == deskripsi &&
        listEquals(other.pilihan, pilihan);
  }

  @override
  int get hashCode =>
      nama.hashCode ^
      baseHarga.hashCode ^
      deskripsi.hashCode ^
      pilihan.hashCode;

  // stringification
  @override
  String toString() {
    return 'OrderPaket(nama: $nama, baseHarga: $baseHarga, deskripsi: $deskripsi, pilihan: $pilihan)';
  }
}

class OrderPilihanPaket {
  final String nama;
  final List<OrderMakanan> makanan;

  // json (de)serialization
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'makanan': makanan.map((e) => e.toJson()).toList(),
      };

  OrderPilihanPaket.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        makanan = json['makanan']
                ?.map((e) => OrderMakanan.fromJson(e))
                .cast<OrderMakanan>()
                .toList() ??
            [];

  const OrderPilihanPaket({
    required this.nama,
    required this.makanan,
  });

  // equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderPilihanPaket &&
        other.nama == nama &&
        listEquals(other.makanan, makanan);
  }

  @override
  int get hashCode => nama.hashCode ^ makanan.hashCode;

  // stringification
  @override
  String toString() => 'OrderPilihanPaket(nama: $nama, makanan: $makanan)';
}

class OrderMakanan {
  final String nama;
  final int harga;

  const OrderMakanan({
    required this.nama,
    required this.harga,
  });

  // json (de)serialization
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'harga': harga,
      };

  OrderMakanan.fromJson(Map<String, dynamic> json)
      : nama = json['nama'],
        harga = json['harga'];

  // equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderMakanan && other.nama == nama && other.harga == harga;
  }

  @override
  int get hashCode => nama.hashCode ^ harga.hashCode;

  // stringification
  @override
  String toString() => 'Makanan(nama: $nama, harga: $harga)';
}
