package com.egolpeappeducativo.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.egolpeappeducativo.backend.model.Pergunta;
import com.egolpeappeducativo.backend.model.enums.Tema;

@Repository 
public interface PerguntaRepository extends  JpaRepository<Pergunta, Integer>{
    @Query(
        value = """
            SELECT * 
            FROM tb_perguntas 
            WHERE tema = :tema 
            ORDER BY RANDOM() 
            LIMIT :quantidade
        """, 
        nativeQuery = true
    )
    List<Pergunta> buscarPerguntasPorTema(
        @Param ("tema") String tema, 
        @Param("quantidade") int quantidade
    );

    @Query(
        value = """
            SELECT *
            FROM tb_perguntas
            ORDER BY RANDOM()
            LIMIT :quantidade
        """,
        nativeQuery = true
    )
    List<Pergunta> buscarPerguntasAleatorias(
        @Param("quantidade") int quantidade
    );

    long countByTema(Tema tema);

}
