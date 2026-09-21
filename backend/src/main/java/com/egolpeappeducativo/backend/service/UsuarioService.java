package com.egolpeappeducativo.backend.service;

import com.egolpeappeducativo.backend.dto.AlterarSenhaRequest;
import com.egolpeappeducativo.backend.model.Usuario;
import com.egolpeappeducativo.backend.repository.UsuarioRepository;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    // Cadastrar ou atualizar usuário
    public Usuario salvarUsuario(Usuario usuario) {

        // NOME
        if (usuario.getNome() == null || usuario.getNome().trim().length() < 2) {
            throw new IllegalArgumentException("Informe um nome válido.");
        }

        // GENERO
        if (usuario.getGenero() == null || usuario.getGenero().trim().isEmpty()) {
            throw new IllegalArgumentException("Selecione um gênero.");
        }

        // EMAIL
        // CORRIGIDO: Alterado & para &&
        if (usuario.getEmail() != null && usuario.getEmail().trim().isEmpty()) {
            usuario.setEmail(null);
        }

        // VALIDAÇÕES EMAIL
        if (usuario.getEmail() != null) {
            String email = usuario.getEmail().trim().toLowerCase();

            if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
                throw new IllegalArgumentException("Digite um e-mail válido.");
            }
            usuario.setEmail(email);

            Optional<Usuario> existente = usuarioRepository.findByEmail(usuario.getEmail());

            if (existente.isPresent() && existente.get().getId() != usuario.getId()) {
                throw new IllegalArgumentException("E-mail já cadastrado.");
            }
        }

        // CELULAR
        // CORRIGIDO: Alterado & para &&
        if (usuario.getCelular() != null && usuario.getCelular().trim().isEmpty()) {
            usuario.setCelular(null);
        }

        // VALIDAÇÕES CELULAR
        if (usuario.getCelular() != null) {
            String celular = usuario.getCelular().replaceAll("\\D", "");

            if (celular.length() != 11) {
                throw new IllegalArgumentException("Celular deve ter 11 números com DDD.");
            }

            usuario.setCelular(celular);

            Optional<Usuario> existente = usuarioRepository.findByCelular(usuario.getCelular());

            // CORRIGIDO: Mensagem ajustada para "Celular já cadastrado."
            if (existente.isPresent() && existente.get().getId() != usuario.getId()) {
                throw new IllegalArgumentException("Celular já cadastrado.");
            }
        }

        // REGRA DE NEGÓCIO: PELO MENOS UM LOGIN
        if (usuario.getEmail() == null && usuario.getCelular() == null) {
            throw new IllegalArgumentException("É necessário cadastrar ao menos um e-mail ou celular para login.");
        }

        // DATA DE NASCIMENTO
        if (usuario.getDataNascimento() == null) {
            throw new IllegalArgumentException("Informe a data de nascimento.");
        }

        return usuarioRepository.save(usuario);
    }

    // Alterar Senha
    public void alterarSenha(Integer id, AlterarSenhaRequest request) {
        Optional<Usuario> usuario = usuarioRepository.findByIdAndSenha(
                id,
                request.getSenhaAtual());

        if (usuario.isEmpty()) {
            throw new IllegalArgumentException("Senha atual incorreta");
        }

        if (request.getNovaSenha() == null || request.getNovaSenha().length() < 6) {
            throw new IllegalArgumentException("A nova senha deve ter pelo menos 6 caracteres");
        }

        usuario.get().setSenha(request.getNovaSenha());

        usuarioRepository.save(usuario.get());
    }

    // Listar todos os usuários
    public List<Usuario> listarUsuarios() {
        return usuarioRepository.findAll();
    }

    // Apagar usuário
    public void apagarUsuario(Integer id) {
        usuarioRepository.deleteById(id);
    }

    // Buscar usuário pelo ID
    public Usuario buscarPorId(Integer id) {
        if (usuarioRepository.existsById(id)) {
            return usuarioRepository.findById(id).get();
        } else {
            return new Usuario();
        }
    }

    // Login por e-mail ou celular
    public Optional<Usuario> realizarLogin(String login, String senha) {
        return usuarioRepository.fazerLogin(login, senha);
    }
}