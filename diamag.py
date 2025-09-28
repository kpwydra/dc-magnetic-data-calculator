# unit: 10^(-6) cm^3/mol
diamag_const_atoms = {
# This dictionary represents the diamagnetic constants for elements in
# different bonding/oxidation_state scenarios. Here's a breakdown of the values:
  "C": {
    'covalent': {
      'ring': -6.24,
      'open_chain': -6.0,
      'ox_state': None,
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+4': -0.1,
      },
    },
  },
    "H": {
    'covalent': {
      'ring': None,
      'open_chain': -2.93,
      'ox_state': None,
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': 0,
        '-1': -5.7,
      },
    },
  },
  "N": {
    'covalent': {
      'ring': -4.61,
      'open_chain': -5.57,
      'ox_state': None,
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+5': -0.1,
      },
    }, 
  },
  "Cl": {
    'covalent': {
      'ring': None,
      'open_chain': -20.1,
      'ox_state': None,
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '-1': -23.4,
      },
    },
  },
}

def get_diamag_contr_for_element(element: dict):
  """ TODO: Search diamag_const_atoms table to return proper diamag
    for given input object """
  
  el_const = diamag_const_atoms[element['name']]
  el_covalent_const = el_const[element['']]



  
  
  #el_const_character = el_const[element['character']]
  #el_const_charge = el_const_character[element['charge']]
  
  #is_open_chain: bool = element['open_chain_atom_no'] > 0
  #is_ring: bool = element['ring_atom_no'] > 0
  #if is_ring:
  #  ...
  #if is_open_chain:
  #  ...
  
  #return ...

def calc_diamag_contr(input_data: dict):
  """ TODO: include open_chain / ring logic, not just 'total_atom_no' """
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
