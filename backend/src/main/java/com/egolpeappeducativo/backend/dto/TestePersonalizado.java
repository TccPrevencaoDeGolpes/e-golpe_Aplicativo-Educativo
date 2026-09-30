package com.egolpeappeducativo.backend.dto;

public class TestePersonalizado {
    
    private int quantidadePerguntas;
    private String tema;
    
	public TestePersonalizado() {
    }

	
	public TestePersonalizado(int quantidadePerguntas, String tema) {
        this.quantidadePerguntas = quantidadePerguntas;
        this.tema = tema;
    }


    public int getQuantidadePerguntas() {
        return quantidadePerguntas;
    }


    public void setQuantidadePerguntas(int quantidadePerguntas) {
        this.quantidadePerguntas = quantidadePerguntas;
    }


    public String getTema() {
        return tema;
    }


    public void setTema(String tema) {
        this.tema = tema;
    }

	
    
}
