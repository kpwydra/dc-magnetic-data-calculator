from element import Element


# unit: 10^(-6) cm^3/mol
diamag_const_atoms = {
# This dictionary represents the diamagnetic constants for elements in
# different bonding/oxidation_state scenarios. Here's a breakdown of the values:
  "C": {
    'covalent': {
      'ring': -6.24,
      'open_chain': -6.0,
      'ox_state': {},
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
      'ox_state': {},
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
      'ox_state': {},
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
      'ox_state': {},
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

input = [
  Element(symbol='C', total_at_no=20, ring_at_no=12, chain_at_no=8),
  Element(symbol='H', total_at_no=25, chain_at_no=25),
  Element(symbol='N', total_at_no=1, ring_at_no=1),
  Element(symbol='Cl', total_at_no=1, first_ox_state='-1', first_ox_state_at_no=1),
]


sum_dia_contr = 0
for element in input:
  
  # searching for elements of input in dictionary
  if element.symbol in diamag_const_atoms:  
      covalent_data = diamag_const_atoms[element.symbol]["covalent"]
      ionic_data = diamag_const_atoms[element.symbol]["ionic"]["charge"]
      ox_state_data = diamag_const_atoms[element.symbol]["covalent"]["ox_state"]
      
      # for given element it takes ring constant and multiplies it with related atoms of the element
      if element.ring_at_no is not None and covalent_data["ring"] is not None:
        sum_dia_contr += covalent_data["ring"] * element.ring_at_no

      # for given element it takes chain constant and multiplies it with related atoms of the element
      if element.chain_at_no is not None and covalent_data["open_chain"] is not None:
        sum_dia_contr += covalent_data["open_chain"] * element.chain_at_no
      
      # if oxidation state was provided for given element: 1. Checks if oxidation states is the same as in dictionary,
      # 2. Takes appropriate constant, 3. Perform multiplication
      # IT IS NOT WORKING AS IT SHOULD. I BELIEVE IT DOESN'T READ ox_state_data[element.first_ox_state] AS FLOAT.
      if element.first_ox_state in ox_state_data and element.first_ox_state_at_no is not None:
        sum_dia_contr += ox_state_data[element.first_ox_state] * element.first_ox_state_at_no
      
      # I gave the possibility for the user to chose two different oxidation states if the molecules is more complicated.
      if element.second_ox_state in ox_state_data and element.second_ox_state_at_no is not None:
        sum_dia_contr += ox_state_data[element.second_ox_state] * element.second_ox_state_at_no

      # Tried to do similiar thing as with ox_state - it is not working properly.
      if element.first_ion_charge in ionic_data and element.first_ion_no is not None:
        sum_dia_contr += ionic_data[element.first_ion_charge] * element.first_ion_no

      # I also gave the possibility for the user to chose more then one ion type if molecule is more complex.
      if element.second_ion_charge in ionic_data and element.second_ion_no is not None:
        sum_dia_contr += ionic_data[element.second_ion_charge] * element.second_ion_no
  print(sum_dia_contr)
         



# I tried to use the nested for loops to get the data from dictionary and use them for 
# calculations with class objects. I rejected the idea because the code started 
# to be too overwhelming.

# sum_dia_contr = 0
# for element in input:
#   for atom, bond_type in diamag_const_atoms.items():
#       for const in bond_type:
#         if element.ring_at_no > 0:
#           sum_dia_contr += diamag_const_atoms.get('ring', {}) * element.ring_at_no
#   print(sum_dia_contr)

def get_diamag_contr_for_element(element: dict):
  """ TODO: Search diamag_const_atoms table to return proper diamag
    for given input object """
  

  el_const = diamag_const_atoms[element['C']]
  print(el_const)



  
  
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
