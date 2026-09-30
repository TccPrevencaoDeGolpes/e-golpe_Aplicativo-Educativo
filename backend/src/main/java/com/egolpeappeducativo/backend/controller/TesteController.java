package com.egolpeappeducativo.backend.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.egolpeappeducativo.backend.dto.FeedbackResponse;
import com.egolpeappeducativo.backend.dto.PerguntaResponse;
import com.egolpeappeducativo.backend.dto.RespostaPergunta;
import com.egolpeappeducativo.backend.dto.TestePersonalizado;
import com.egolpeappeducativo.backend.dto.TesteResponse;
import com.egolpeappeducativo.backend.service.TesteService;

@RestController 
@RequestMapping("/testes") 
@CrossOrigin 
public class TesteController {

    @Autowired 
    private TesteService testeService;

    //LISTAR TESTES
    //GET /testes
    @GetMapping 
    public ResponseEntity<List<TesteResponse>> listarTestes(){
        return ResponseEntity.ok(
            testeService.listarTestes()
        );
    }

    //BUSCAR PERGUNTAS
    // GET /testes/1/perguntas
    @GetMapping("/{id}/perguntas") 
    public  ResponseEntity<List<PerguntaResponse>> 
    buscarPerguntas(@PathVariable int id) {

        return ResponseEntity.ok(
            testeService.buscarPerguntasDoTeste(id)
        ); 
    }

    //CRIAR TESTE PERSONALIZADO
    @PostMapping("/personalizado")
    public ResponseEntity<List<PerguntaResponse>> criarPersonalizado(
        @RequestBody TestePersonalizado dto) {
            return ResponseEntity.ok(
                testeService.criarTestePersonalizado(dto)
            );
    }

    @PostMapping("/pergunta/responder")
    public ResponseEntity<FeedbackResponse> responderPergunta(
        @RequestBody RespostaPergunta dto) {
        return ResponseEntity.ok(
            testeService.responderPergunta(dto)
        );
    }

}
