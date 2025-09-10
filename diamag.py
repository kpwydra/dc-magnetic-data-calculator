def calc_diamag_contrib(formula: str):
    result = {}

    formula = formula.upper()
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
                result[key] = int(value)
                key, value = '', ''
        else:
            result[key] = int(curr)

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




