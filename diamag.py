def calc_atoms_no(formula: str):
    result = {}

    key, value = '', ''
    for i in range(len(formula)):
        curr = formula[i]
 
        if i+1 < len(formula):
            next = formula[i+1]
            if curr.isalpha() and next.isalpha():
                key += curr
            elif curr.isalpha() and next.isdigit():
                key += curr
            elif curr.isdigit() and next.isdigit():
                value += curr
            elif curr.isdigit() and next.isalpha():
                value += curr
                result[key.capitalize()] = int(value)
                key, value = '', ''
        else:
            value += curr
            result[key.capitalize()] = int(value)

    return result

# 1) dać wszystkie litery duże, żeby można było jednoznacznie
# analizować symbole pierwiastków
# 2) w pętli for sprawdzać każdy znak. Wewnątrz pętli for
# stworzyć if statement oraz pusty string gdzieś w funkcji.
# działanie pętli: 
# gdy litera -> dodaj do stringa,
# gdy cyfra -> utnij stringa. Ucięty string to symbol pierwiastka.
# 3) stworzyć innego pustego stringa -> w pętli for: 
# gdy cyfra -> dodaj do stringa cyfrę 
# -> gdy litera zakończ stringa -> zamień stringa na liczbę z int()
# 4) w pętlach dodać komendę result['pierwiastek'] = [liczba]


# unit: 10^(-6) cm^3/mol
diamag_const_atoms = {
    "Ag": -31.0,
    "Al": -13.0,
    "B": -7.0,
    "Br": -30.6,
    "C": -6.00, # aliphatic
    "Cl": -20.1,
    "F": -6.3,
    "H": -2.93,
    "I": -44.6,
    "N": -5.57, # open chain
    "O": -4.6,
    "P": -26.3,
    "S": -15.0,
    "Se": -23.0,
    "Si": -13
}

def calc_diamag_contr(result):
    
    sum_dia_contr = 0
    for element in result:
        sum_dia_contr += result[element] * diamag_const_atoms[element]
    return sum_dia_contr



