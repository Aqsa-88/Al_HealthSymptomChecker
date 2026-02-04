from typing import List, Dict

def predict_ml(symptoms: List[str]) -> Dict[str, float]:
    # In a real app, this would load a pickle file (model.pkl) and predict
    # Here we mock it
    symptoms_lower = [s.lower() for s in symptoms]
    probs = {}
    
    if "fever" in symptoms_lower:
        probs["Flu"] = 0.7
        probs["Cold"] = 0.2
    elif "headache" in symptoms_lower:
        probs["Migraine"] = 0.6
        probs["Tension Headache"] = 0.3
    else:
        probs["Unknown"] = 0.1
        
    return probs
