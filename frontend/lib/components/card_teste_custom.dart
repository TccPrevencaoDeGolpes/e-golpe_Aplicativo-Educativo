import 'package:flutter/material.dart';
import 'package:frontend/model/teste.dart';

class CardtesteCustom extends StatelessWidget {
  final Teste teste;
  final VoidCallback onTap;

  const CardtesteCustom({
    super.key,
    required this.teste,
    required this.onTap,
  });

  //COR DE FUNDO - STATUS DO TESTE 
  Color get _statusBackgroundColor {
    switch (teste.status) {
      
      case StatusTeste.concluido:
        return const Color(0xFF15803D);

      case StatusTeste.disponivel:
        return const Color(0xFFF59E0B);

      case StatusTeste.bloqueado:
        return const Color(0xFFF1F5F9);
    }
  }
  //COR DO TEXTO - STATUS TESTE 
  Color get _statusTextColor {
    switch(teste.status) {
      
      case StatusTeste.disponivel:
        return  Colors.black;
      case StatusTeste.bloqueado:
        return const Color(0xFF1E3A8A);
      default:
      return Colors.white;
    }
  }

  //Texto STATUS TESTE
  String get _statusText {
    switch (teste.status) {
      
      case StatusTeste.concluido:
        return 'Concluído';
      case StatusTeste.disponivel:
        return 'Disponível';
      case StatusTeste.bloqueado:
        return 'Bloqueado';
    }
  }




  @override
  Widget build(BuildContext context) {
    final bool isbloqueado = teste.status == StatusTeste.bloqueado;

    return Opacity(
      opacity: isbloqueado ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E3A8A), width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isbloqueado ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                //titulo
                Text(
                  teste.titulo,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //ICONE 
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isbloqueado ? Icons.lock_outline : Icons.smartphone,
                        size: 32,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(width: 16),
                    //DESCRIÇÃO + QUANTIDADE PERGUNTAS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teste.descricao,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${teste.quantidadePerguntas} perguntas',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isbloqueado)
                    const Icon(Icons.chevron_right, size: 32, color: Colors.black),
                  ],
                ),
                const SizedBox(height: 16),
                //status alinhado à direita
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusText.toUpperCase(),
                      style: TextStyle(
                        color: _statusTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}