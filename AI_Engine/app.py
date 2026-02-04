from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict
import uvicorn
from models.rule_based_model import evaluate_rules
from models.ml_model import predict_ml

app = FastAPI(title="AI Symptom Checker Microservice")

class SymptomRequest(BaseModel):
    symptoms: List[str]

class AssessmentResponse(BaseModel):
    severity: str
    details: str
    probabilities: Dict[str, float]

@app.post("/predict", response_model=AssessmentResponse)
def assess_symptoms(request: SymptomRequest):
    try:
        severity = evaluate_rules(request.symptoms)
        probabilities = predict_ml(request.symptoms)
        
        return {
            "severity": severity,
            "details": f"Processed {len(request.symptoms)} symptoms.",
            "probabilities": probabilities
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
