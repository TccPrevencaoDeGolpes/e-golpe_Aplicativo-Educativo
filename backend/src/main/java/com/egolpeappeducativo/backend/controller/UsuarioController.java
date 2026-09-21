
package com.egolpeappeducativo.backend.controller;
import com.egolpeappeducativo.backend.model.Usuario;
import com.egolpeappeducativo.backend.service.UsuarioService;
import com.egolpeappeducativo.backend.dto.AlterarSenhaRequest;
import com.egolpeappeducativo.backend.dto.LoginRequest;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    // POST /usuarios
    @PostMapping
    public ResponseEntity<?> gravar(@RequestBody Usuario obj) {
        try {
            usuarioService.salvarUsuario(obj);
            return ResponseEntity.status(HttpStatus.CREATED).build();

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // GET /usuarios
    @GetMapping
    public List<Usuario> listar() {
        return usuarioService.listarUsuarios();
    }

    // GET /usuarios/{id}
    @GetMapping("/{id}")
    public Usuario carregar(@PathVariable("id") Integer id) {
        return usuarioService.buscarPorId(id);
    }

    // PUT /usuarios/{id}
    @PutMapping("/{id}")
    public ResponseEntity<?> alterar(
            @PathVariable("id") Integer id,
            @RequestBody Usuario obj) {
        try {
            obj.setId(id);
            usuarioService.salvarUsuario(obj);
            return ResponseEntity.ok().build();

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}/senha")
    public ResponseEntity<?> alterarSenha(
            @PathVariable("id") Integer id,
            @RequestBody AlterarSenhaRequest request) {
        try {
            usuarioService.alterarSenha(id, request);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // DELETE /usuarios/{id}
    @DeleteMapping("/{id}")
    public void apagar(@PathVariable("id") Integer id) {
        usuarioService.apagarUsuario(id);
    }

    // LOGIN
    // POST /usuarios/login
    @PostMapping("/login")
    public ResponseEntity<?> fazerLogin(@RequestBody LoginRequest request) {

        Optional<Usuario> retorno = usuarioService.realizarLogin(
                request.getLogin(),
                request.getSenha());

        if (retorno.isPresent()) {
            // Retorna 200 ok
            return ResponseEntity.ok(retorno.get());
        }

        //Retorna 401 Unauthorized
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body("E-mail/celular ou senha incorretos.");
    }
}
