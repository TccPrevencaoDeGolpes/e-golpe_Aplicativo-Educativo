package com.egolpeappeducativo.backend.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.egolpeappeducativo.backend.dto.FeedbackResponse;
import com.egolpeappeducativo.backend.dto.PerguntaResponse;
import com.egolpeappeducativo.backend.dto.RespostaPergunta;
import com.egolpeappeducativo.backend.dto.TestePersonalizado;
import com.egolpeappeducativo.backend.dto.TesteResponse;
import com.egolpeappeducativo.backend.model.Pergunta;
import com.egolpeappeducativo.backend.model.Teste;
import com.egolpeappeducativo.backend.model.enums.Tema;
import com.egolpeappeducativo.backend.repository.TesteRepository;
import com.egolpeappeducativo.backend.repository.PerguntaRepository;

@Service
public class TesteService {

    @Autowired
    private TesteRepository testeRepository;

    @Autowired
    private PerguntaRepository perguntaRepository;

    // LISTAR TODOS OS TESTES
    public List<TesteResponse> listarTestes() {
        return testeRepository
                .findAll()
                .stream()
                .map(teste -> new TesteResponse(
                        teste.getId(),
                        teste.getTitulo(),
                        teste.getDescricao(),
                        teste.getQuantidadePerguntas(),
                        teste.getStatus()))
                .toList();
    }

    // BUSCAR TESTE ESPECÍFICO
    public Teste buscarPorId(int id) {
        return testeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Teste não encontrado"));
    }

    // PUXAR PERGUNTAS DO TESTE
    public List<PerguntaResponse> buscarPerguntasDoTeste(int testeId) {
        Teste teste = buscarPorId(testeId);

        return teste.getPerguntas()
                .stream()
                .map(PerguntaResponse::new)
                .toList();
    }

    // CRIAR TESTE PERSONALIZADO
    public List<PerguntaResponse> criarTestePersonalizado(TestePersonalizado dto) {

        if (dto == null) {
            throw new RuntimeException("Dados do teste não foram fornecidos.");
        }

        int quantidade = dto.getQuantidadePerguntas();

        if (quantidade != 5 && quantidade != 10 && quantidade != 20) {
            throw new RuntimeException("A quantidade deve ser 5, 10 ou 20.");
        }

        List<Pergunta> perguntas;
        String temaInput = dto.getTema();

        boolean isAleatorio = temaInput == null
                || temaInput.trim().isEmpty()
                || "ALEATORIO".equalsIgnoreCase(temaInput.trim());

        if (isAleatorio) {
            long totalDisponivel = perguntaRepository.count();

            if (totalDisponivel < quantidade) {
                throw new RuntimeException(
                        "Não existem perguntas suficientes na base de dados para criar um teste aleatório.");
            }

            perguntas = perguntaRepository.buscarPerguntasAleatorias(quantidade);

        } else {
            Tema tema;
            try {
                tema = Tema.valueOf(temaInput.trim().toUpperCase());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Tema inválido.");
            }

            long quantidadeDisponivel = perguntaRepository.countByTema(tema);

            if (quantidadeDisponivel < quantidade) {
                throw new RuntimeException("Não existem perguntas suficientes para o tema selecionado.");
            }

            perguntas = perguntaRepository.buscarPerguntasPorTema(tema.name(), quantidade);
        }

        if (perguntas == null || perguntas.size() < quantidade) {
            throw new RuntimeException("Não existem perguntas suficientes para criar o teste.");
        }

        // Mapeia para PerguntaResponse DTO antes de retornar
        return perguntas.stream()
                .map(PerguntaResponse::new)
                .toList();
    }

    public FeedbackResponse responderPergunta(RespostaPergunta dto) {
        Pergunta pergunta = perguntaRepository
                .findById(dto.getPerguntaId())
                .orElseThrow(() -> new RuntimeException("Pergunta não encontrada"));

        int alternativaSelecionada = dto.getAlternativaSelecionada();

        boolean correta = alternativaSelecionada == pergunta.getAlternativaCerta();

        String feedback = pergunta.getFeedbacks()
                .get(alternativaSelecionada);

        return new FeedbackResponse(
                correta,
                feedback,
                pergunta.getAlternativaCerta());
    }

}
