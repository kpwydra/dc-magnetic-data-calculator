compound_formula = input('>')

elements = {
    "C": "carbon",
    "H": "hydrogen"
}

element_symbol_list = []
for element in compound_formula:
    element_coefficient = ''
    if element in elements:
        element_symbol_list.append(element)
    elif element not in elements:
        element_coefficient += "{element}"
        element_symbol_list.append(element_coefficient)

print(element_symbol_list)
