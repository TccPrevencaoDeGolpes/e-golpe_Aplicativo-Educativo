class Usuario {
  int? id;
  String? nome;
  String? email;
  String? celular;
  String? senha;
  String? genero;
  DateTime? dataNascimento;
  


  Usuario({
    this.id, 
    this.nome, 
    this.email, 
    this.celular, 
    this.senha, 
    this.genero, 
    this.dataNascimento});


  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    celular = json['celular'];
    senha = json['senha'];
    genero = json['genero'];
    dataNascimento = json['dataNascimento'] != null 
    ? DateTime.parse(json['dataNascimento']) 
    : null; 
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'celular': celular,
      'senha': senha,
      'genero': genero,
      //ISO 8601 - YYYY-MM-DD + horario -> split(T).first -> não pega horario 
      'dataNascimento': dataNascimento?.toIso8601String().split('T').first,  
    };
  }
}