package com.egolpeappeducativo.backend.model;

import com.egolpeappeducativo.backend.model.enums.Tema;
import com.egolpeappeducativo.backend.model.enums.TipoPergunta;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity 
@Table(name = "tb_perguntas")
public class Pergunta {

    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private int id;

    private  String enunciado;
    private String remetente;

    @Column (columnDefinition = "TEXT")
    private String mensagem;

    @ElementCollection
    @CollectionTable (name = "tb_pergunta_alternativas", joinColumns = @JoinColumn(name = "pergunta_id")) 
    @Column(name = "alternativa")
    private List<String> alternativas = new ArrayList<>();

    private Integer alternativaCerta;

    @ElementCollection 
    @CollectionTable (name = "tb_pergunta_feedbacks", joinColumns = @JoinColumn(name = "pergunta_id"))
    @Column (name = "feedback", columnDefinition = "TEXT")
    private List<String> feedbacks = new ArrayList<>();

    @Enumerated (EnumType.STRING)
    private Tema tema;
    
    @Enumerated (EnumType.STRING)
    private TipoPergunta tipoPergunta;

    @ManyToMany (mappedBy = "perguntas")
    private List<Teste> testes = new ArrayList<>();

    public Pergunta() {}



    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEnunciado() {
        return enunciado;
    }

    public void setEnunciado(String enunciado) {
        this.enunciado = enunciado;
    }

    public String getRemetente() {
        return remetente;
    }

    public void setRemetente(String remetente) {
        this.remetente = remetente;
    }

    public String getMensagem() {
        return mensagem;
    }

    public void setMensagem(String mensagem) {
        this.mensagem = mensagem;
    }

    public List<String> getAlternativas() {
        return alternativas;
    }

    public void setAlternativas(List<String> alternativas) {
        this.alternativas = alternativas;
    }

    public Integer getAlternativaCerta() {
        return alternativaCerta;
    }

    public void setAlternativaCerta(Integer alternativaCerta) {
        this.alternativaCerta = alternativaCerta;
    }

    public List<String> getFeedbacks() {
        return feedbacks;
    }

    public void setFeedbacks(List<String> feedbacks) {
        this.feedbacks = feedbacks;
    }

    public Tema getTema() {
        return tema;
    }

    public void setTema(Tema tema) {
        this.tema = tema;
    }

    public TipoPergunta getTipoPergunta() {
        return tipoPergunta;
    }

    public void setTipoPergunta(TipoPergunta tipoPergunta) {
        this.tipoPergunta = tipoPergunta;
    }

    public List<Teste> getTestes() {
        return testes;
    }

    public void setTestes(List<Teste> testes) {
        this.testes = testes;
    }

}
