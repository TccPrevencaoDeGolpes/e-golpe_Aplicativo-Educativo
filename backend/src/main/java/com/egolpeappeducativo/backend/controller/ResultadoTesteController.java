package com.egolpeappeducativo.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.egolpeappeducativo.backend.dto.ResultadoTesteResponse;
import com.egolpeappeducativo.backend.service.ResultadoTesteService;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/resultados")
public class ResultadoTesteController {

        @Autowired 
        private ResultadoTesteService resultadoTesteService;

        @PostMapping 
        public ResponseEntity<?> gravar(@RequestBody ResultadoTesteResponse dto) {
            try {
                resultadoTesteService.salvarResultado(dto);
                return ResponseEntity.status(HttpStatus.CREATED).build();
            } catch(IllegalArgumentException e ) {
                return ResponseEntity.badRequest().body(e.getMessage());
            }
        }
}
