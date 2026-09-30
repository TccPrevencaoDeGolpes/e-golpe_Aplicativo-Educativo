package com.egolpeappeducativo.backend.model;

import jakarta.persistence.*;

@Entity
@Table (name = "tb_resultados_teste")
public class ResultadoTeste {

     @Id 
     @GeneratedValue (strategy = GenerationType.IDENTITY)
     private int id;

     @ManyToOne 
     @JoinColumn (name = "usuario_id")
     private Usuario usuario;
     
     @ManyToOne(optional = true) 
     @JoinColumn (name = "teste_id", nullable = true)
     private Teste teste;

     private Integer acertos;
     private Integer totalPerguntas;

     public int getId() {
         return id;
     }
     public void setId(int id) {
         this.id = id;
     }
     public Usuario getUsuario() {
         return usuario;
     }
     public void setUsuario(Usuario usuario) {
         this.usuario = usuario;
     }
     public Teste getTeste() {
         return teste;
     }
     public void setTeste(Teste teste) {
         this.teste = teste;
     }
     public Integer getAcertos() {
         return acertos;
     }
     public void setAcertos(Integer acertos) {
         this.acertos = acertos;
     }
     public Integer getTotalPerguntas() {
         return totalPerguntas;
     }
     public void setTotalPerguntas(Integer totalPerguntas) {
         this.totalPerguntas = totalPerguntas;
     }
}
