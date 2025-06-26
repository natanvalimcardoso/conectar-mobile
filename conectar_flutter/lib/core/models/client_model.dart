class ClientModel {
  final String id;
  final String razaoSocial;
  final String nomeNaFachada;
  final String cnpj;
  final String status;
  final String cep;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String? complemento;
  final bool conectaPlus;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModel({
    required this.id,
    required this.razaoSocial,
    required this.nomeNaFachada,
    required this.cnpj,
    required this.status,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.complemento,
    required this.conectaPlus,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      razaoSocial: json['razaoSocial'],
      nomeNaFachada: json['nomeNaFachada'],
      cnpj: json['cnpj'],
      status: json['status'],
      cep: json['cep'],
      rua: json['rua'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      complemento: json['complemento'],
      conectaPlus: json['conectaPlus'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'razaoSocial': razaoSocial,
      'nomeNaFachada': nomeNaFachada,
      'cnpj': cnpj,
      'status': status,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
      'conectaPlus': conectaPlus,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ClientModel copyWith({
    String? id,
    String? razaoSocial,
    String? nomeNaFachada,
    String? cnpj,
    String? status,
    String? cep,
    String? rua,
    String? numero,
    String? bairro,
    String? cidade,
    String? estado,
    String? complemento,
    bool? conectaPlus,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      nomeNaFachada: nomeNaFachada ?? this.nomeNaFachada,
      cnpj: cnpj ?? this.cnpj,
      status: status ?? this.status,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      complemento: complemento ?? this.complemento,
      conectaPlus: conectaPlus ?? this.conectaPlus,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ClientModel &&
        other.cnpj == cnpj; // Dois clientes são iguais se têm o mesmo CNPJ
  }

  @override
  int get hashCode => cnpj.hashCode; // Hash baseado no CNPJ
} 