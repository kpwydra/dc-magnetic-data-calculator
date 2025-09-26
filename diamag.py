# unit: 10^(-6) cm^3/mol
diamag_const_atoms = {
  "Ag": -31.0,
  "Al": -13.0,
  "B": -7.0,
  "Br": -30.6,
  "C": {
    'covalent': {
      'default': None,
      'aromatic': -6.24,
      'aliphatic': -6.0,
    },
    'ionic': {
      'aromatic': None,
      'aliphatic': None,
      'ox_state': {
        '+4': -0.1,
      },
    },
  },
  "Cl": -20.1,
  "F": -6.3,
  "H": # This dictionary represents the diamagnetic constants for the element H (Hydrogen) in
  # different bonding scenarios. Here's a breakdown of the values:
  {
    'covalent': {
      'default': None,
      'aromatic': None,
      'aliphatic': -2.93,
    },
    'ionic': {
      'aromatic': None,
      'aliphatic': None,
      'ox_state': {
        '+1': 0,
        '-1': 999,  # todo - update real vlaue
      },
    },
  },
  "I": -44.6,
  "N": -5.57, # open chain
  "O": -4.6,
  "P": -26.3,
  "S": -15.0,
  "Se": -23.0,
  "Si": -13,
}

def get_diamag_contr_for_element(element: dict):
  """ TODO: Search diamag_const_atoms table to return proper diamag
    for given input object """
  el_const = diamag_const_atoms[element['name']]
  el_const_character = el_const[element['character']]
  el_const_ox_state = el_const_character[element['ox_state']]
  
  is_aliphatic: bool = element['aliphatic_atom_no'] > 0
  is_aromatic: bool = element['aromatic_atom_no'] > 0
  if is_aromatic:
    ...
  if is_aliphatic:
    ...
  
  return ...

def calc_diamag_contr(input_data: dict):
  """ TODO: include aliphatic / aromatic logic, not just 'total_atom_no' """
  sum_dia_contr = 0
  for element in input_data:
    sum_dia_contr += get_diamag_contr_for_element(element=element) * element['total_atom_no']
  
  return sum_dia_contr


def calc_atoms_no(formula: str):
    """
    Old version of input structure
    """
    input_data = {}

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
                input_data[key.capitalize()] = int(value)
                key, value = '', ''
        else:
            value += curr
            input_data[key.capitalize()] = int(value)

    return input_data
