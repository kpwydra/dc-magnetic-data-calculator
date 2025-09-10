import re

def calc_diamag_contrib(formula: str):
    pattern = r"([A-Z][a-z]*)(\d+)"
    matches = re.findall(pattern, formula)
    
    return {element: int(count) for element, count in matches}

