package com.egolpeappeducativo.backend.repository;

import com.egolpeappeducativo.backend.model.Usuario;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {

    @Query("""
        SELECT u
        FROM Usuario u
        WHERE (u.email = :login OR u.celular = :login)
        AND u.senha = :senha
    """)
    Optional<Usuario> fazerLogin(
        @Param("login") String login,
        @Param("senha") String senha
    );

    Optional<Usuario> findByIdAndSenha(Integer id, String senha);

    Optional<Usuario>  findByEmail(String email);
    Optional<Usuario> findByCelular(String celular);
    
}