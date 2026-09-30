package com.egolpeappeducativo.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.egolpeappeducativo.backend.dto.ResultadoTesteResponse;
import com.egolpeappeducativo.backend.model.ResultadoTeste;
import com.egolpeappeducativo.backend.model.Teste;
import com.egolpeappeducativo.backend.model.Usuario;
import com.egolpeappeducativo.backend.repository.ResultadoTesteRepository;
import com.egolpeappeducativo.backend.repository.TesteRepository;
import com.egolpeappeducativo.backend.repository.UsuarioRepository;

@Service
public class ResultadoTesteService {

    @Autowired
    private TesteRepository testeRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private ResultadoTesteRepository resultadoTesteRepository;

    public ResultadoTeste salvarResultado(ResultadoTesteResponse dto) {
        // 1. Apenas o usuário é obrigatório (o testeId pode ser null em testes personalizados)
        if (dto.getUsuarioId() == null) {
            throw new IllegalArgumentException("O usuário é obrigatório para salvar o resultado.");
        }

        if (dto.getAcertos() == null || dto.getTotalPerguntas() == null) {
            throw new IllegalArgumentException("A pontuação do teste está incompleta.");
        }

        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new IllegalArgumentException("Usuário não encontrado com id: " + dto.getUsuarioId()));

        ResultadoTeste resultado = new ResultadoTeste();
        resultado.setUsuario(usuario);

        // 2. Busca e associa o Teste SOMENTE se o testeId foi enviado
        if (dto.getTesteId() != null) {
            Teste teste = testeRepository.findById(dto.getTesteId())
                    .orElseThrow(() -> new IllegalArgumentException("Teste não encontrado com id: " + dto.getTesteId()));
            resultado.setTeste(teste);
        } else {
            resultado.setTeste(null); // Teste personalizado
        }

        resultado.setAcertos(dto.getAcertos());
        resultado.setTotalPerguntas(dto.getTotalPerguntas());

        return resultadoTesteRepository.save(resultado);
    }
}
