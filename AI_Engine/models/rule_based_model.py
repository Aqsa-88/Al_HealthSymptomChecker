from typing import List

def evaluate_rules(symptoms: List[str]) -> str:
    symptoms_set = set([s.lower() for s in symptoms])
    
    if {"headache", "fever", "stiff neck"}.issubset(symptoms_set):
        return "High"
    if {"chest pain", "shortness of breath"}.intersection(symptoms_set):
        return "High"
    if "headache" in symptoms_set and "nausea" in symptoms_set:
        return "Medium"
    if len(symptoms_set) == 1 and "headache" in symptoms_set:
        return "Low"
    
    # Default based on count of valid symptoms
    if len(symptoms_set) >= 3:
        return "Medium"
    return "Low"
