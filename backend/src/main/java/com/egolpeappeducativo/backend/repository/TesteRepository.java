package com.egolpeappeducativo.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.egolpeappeducativo.backend.model.Teste;

@Repository 
public interface TesteRepository extends JpaRepository<Teste, Integer> {

}
