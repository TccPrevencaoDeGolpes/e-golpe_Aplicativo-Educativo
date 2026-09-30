package com.egolpeappeducativo.backend.model;

import java.util.ArrayList;
import java.util.List;

import com.egolpeappeducativo.backend.model.enums.StatusTeste;

import jakarta.persistence.*;


@Entity 
@Table (name = "tb_testes")
public class Teste {

    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private int id;

    private String titulo;
    private String descricao;
    private int quantidadePerguntas;

    @Enumerated (EnumType.STRING)
    private StatusTeste status;

    @ManyToMany 
    @JoinTable (
        name= "tb_teste_perguntas",
        joinColumns = @JoinColumn (name = "teste_id"),
        inverseJoinColumns = @JoinColumn (name = "pergunta_id")
    )

    private List<Pergunta> perguntas = new ArrayList<>();

    public Teste() {}




    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public int getQuantidadePerguntas() {
        return quantidadePerguntas;
    }

    public void setQuantidadePerguntas(int quantidadePerguntas) {
        this.quantidadePerguntas = quantidadePerguntas;
    }

    public StatusTeste getStatus() {
        return status;
    }

    public void setStatus(StatusTeste status) {
        this.status = status;
    }

    public List<Pergunta> getPerguntas() {
        return perguntas;
    }




    public void setPerguntas(List<Pergunta> perguntas) {
        this.perguntas = perguntas;
    }

    

    
    

    

    
}
