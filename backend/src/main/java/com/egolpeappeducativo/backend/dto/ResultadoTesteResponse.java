package com.egolpeappeducativo.backend.dto;

public class ResultadoTesteResponse {
    private Integer usuarioId;
    private Integer testeId;
    private Integer totalPerguntas;
    private Integer acertos;
    private Integer erros;
    private Double porcentagem;
    
    public Integer getUsuarioId() {
        return usuarioId;
    }
    public void setUsuarioId(Integer usuarioId) {
        this.usuarioId = usuarioId;
    }
    
    public Integer getTesteId() {
        return testeId;
    }
    public void setTesteId(Integer testeId) {
        this.testeId = testeId;
    }
    public Integer getTotalPerguntas() {
        return totalPerguntas;
    }
    public void setTotalPerguntas(Integer totalPerguntas) {
        this.totalPerguntas = totalPerguntas;
    }
    public Integer getAcertos() {
        return acertos;
    }
    public void setAcertos(Integer acertos) {
        this.acertos = acertos;
    }
    public Integer getErros() {
        return erros;
    }
    public void setErros(Integer erros) {
        this.erros = erros;
    }
    public Double getPorcentagem() {
        return porcentagem;
    }
    public void setPorcentagem(Double porcentagem) {
        this.porcentagem = porcentagem;
    }

    
}
