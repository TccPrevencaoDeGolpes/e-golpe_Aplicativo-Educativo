package com.egolpeappeducativo.backend.dto;

import java.util.List;

import com.egolpeappeducativo.backend.model.Pergunta;
import com.egolpeappeducativo.backend.model.enums.Tema;
import com.egolpeappeducativo.backend.model.enums.TipoPergunta;

public class PerguntaResponse {

    private int id;
    private String enunciado;
    private String remetente;
    private String mensagem;
    private List<String> alternativas;
    private Integer alternativaCerta;
    private List<String> feedbacks;
    private Tema tema;
    private TipoPergunta tipoPergunta;

	public PerguntaResponse(
        Pergunta pergunta) {

		this.id = pergunta.getId();
        this.enunciado = pergunta.getEnunciado();
        this.remetente = pergunta.getRemetente();
        this.mensagem = pergunta.getMensagem();
        this.alternativas = pergunta.getAlternativas();
        this.alternativaCerta = pergunta.getAlternativaCerta();
        this.feedbacks = pergunta.getFeedbacks();
        this.tema = pergunta.getTema();
        this.tipoPergunta = pergunta.getTipoPergunta();
	}

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

    


    

}
