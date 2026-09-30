package com.egolpeappeducativo.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.egolpeappeducativo.backend.model.ResultadoTeste;

public interface ResultadoTesteRepository extends JpaRepository<ResultadoTeste, Integer> {

    List<ResultadoTeste> findByUsuarioId(int usuarioId);
}
