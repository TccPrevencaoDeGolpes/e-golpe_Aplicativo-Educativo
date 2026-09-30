package com.egolpeappeducativo.backend.dto;

import com.egolpeappeducativo.backend.model.enums.StatusTeste;

public class TesteResponse {

    private int id;
    private String titulo;
    private String descricao;
    private int quantidadePerguntas;
    private StatusTeste status;

    public TesteResponse(
            int id,
            String titulo,
            String descricao,
            int quantidadePerguntas,
            StatusTeste status) {
        this.id = id;
        this.titulo = titulo;
        this.descricao = descricao;
        this.quantidadePerguntas = quantidadePerguntas;
        this.status = status;
    }

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

    

}
