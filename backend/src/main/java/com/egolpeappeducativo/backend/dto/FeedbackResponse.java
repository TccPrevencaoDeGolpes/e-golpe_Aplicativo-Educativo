package com.egolpeappeducativo.backend.dto;

public class FeedbackResponse {

    private boolean correta;
    private String feedback;       
    private int alternativaCerta;

	public FeedbackResponse(
        boolean correta, 
        String feedback, 
        int alternativaCerta) {

		this.correta = correta;
		this.feedback = feedback;
		this.alternativaCerta = alternativaCerta;
	}

    public boolean isCorreta() {
        return correta;
    }

    public void setCorreta(boolean correta) {
        this.correta = correta;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public int getAlternativaCerta() {
        return alternativaCerta;
    }

    public void setAlternativaCerta(int alternativaCerta) {
        this.alternativaCerta = alternativaCerta;
    }

    

    
}
