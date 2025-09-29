# unit: 10^(-6) cm^3/mol
diamag_const_atoms = {
# This dictionary represents the diamagnetic constants for elements in
# different bonding/oxidation_state/ionic_charge scenarios. Here's a breakdown of the values:
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
  "Ag": {
     'covalent': {
      'ring': None,
      'open_chain': -31.0,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': -28,
        '+2': -24, # uncetrain value according to the article (DOI: 10.1021/ed085p532)
      },
    },   
  },
  "Al": {
     'covalent': {
      'ring': None,
      'open_chain': -13.0,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -2,
      },
    },     
  },
  'As': {
     'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {
         '(III)': -20.9,
         '(V)': -43.0,
      },
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -9, # uncetrain value according to the article (DOI: 10.1021/ed085p532)
        '+5': -6,
      },
    },     
  },
  'Au': {
     'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': -40, # uncetrain value according to the article (DOI: 10.1021/ed085p532)
        '+3': -32,
       },
    },     
  },
  'B': {
     'covalent': {
      'ring': None,
      'open_chain': -7.0,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -0.2,
       },
    },     
  },
  'Ba': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -26.5,
      },
    },
  },
  'Be': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -0.4,
      },
    },
  },
  'Bi': {
    'covalent': {
      'ring': None,
      'open_chain': -192.0,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -25, # uncetrain value according to the article (DOI: 10.1021/ed085p532)
        '+5': -23,
      },
    },
  },
  "Br": {
    'covalent': {
      'ring': None,
      'open_chain': -30.6,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '-1': -34.6,
        '+5': -6, 
      },
    },
  },
  "Ca": {
    'covalent': {
      'ring': None,
      'open_chain': -15.9,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -10.4, 
      },
    },
  },
  "Cd": {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -24, 
      },
    },
  },
  "Ce": {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -20,
        '+4': -17,
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
        '+5': -2,
      },
    },
  },
  "Co": {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -12,
        '+3': -10,
      },
    },
  },
  'Cr': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -15,
        '+3': -11,
        '+4': -8,
        '+5': -5,
        '+6': -3,
      },
    },
  },
  'Cs': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': -35.0,
      },
    },
  },
  'Cu': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': -12,
        '+2': -11,
      },
    },
  },
  'Dy': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -19,
      },
    },
  },
  'Er': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -18,
      },
    },
  },
  'Eu': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -22,
        '+3': -20,
      },
    },
  },
  'F': {
    'covalent': {
      'ring': None,
      'open_chain': -6.3,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '-1': -9.1,
      },
    },
  },
  'Fe': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -13,
        '+3': -10,
      },
    },
  },
  'Ga': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -8,
      },
    },
  },
  'Ge': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+4': -7,
      },
    },
  },
  'Gd': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -20,
      },
    },
  },
  'Hf': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+4': -16,
      },
    },
  },
  'Hg': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {
         '(II)': -33.0,
      },
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+2': -40.0,
      },
    },
  },
  'Ho': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -19,
      },
    },
  },
  'I': {
    'covalent': {
      'ring': None,
      'open_chain': -44.6,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '-1': -50.6,
        '+5': -12,
        '+7': -10,
      },
    },
  },
  'In': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+3': -19,
      },
    },
  },
  'Ir': {
    'covalent': {
      'ring': None,
      'open_chain': None,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': -50,
        '+2': -42,
        '+3': -35,
        '+4': -29,
        '+5': -20,
      },
    },
  },
  'K': {
    'covalent': {
      'ring': None,
      'open_chain': -18.5,
      'ox_state': {},
    },
    'ionic': {
      'ring': None,
      'open_chain': None,
      'charge': {
        '+1': -14.9,
      },
    },
  },
}


def calc_diamag_contr(input_data: list):
  sum_dia_contr = 0

  for element in input_data:
    
    # searching for elements of input in dictionary
    if element.symbol in diamag_const_atoms:  
        covalent_data = diamag_const_atoms[element.symbol]["covalent"]
        ionic_data = diamag_const_atoms[element.symbol]["ionic"]["charge"]
        ox_state_data = diamag_const_atoms[element.symbol]["covalent"]["ox_state"]
        
        # for given element it takes ring constant and multiplies it with related atom No of the element
        if element.ring_at_no is not None and covalent_data["ring"] is not None:
          sum_dia_contr += covalent_data["ring"] * element.ring_at_no

        # for given element it takes chain constant and multiplies it with related atom No of the element
        if element.chain_at_no is not None and covalent_data["open_chain"] is not None:
          sum_dia_contr += covalent_data["open_chain"] * element.chain_at_no
        
        # if oxidation state was provided for given element: 1. Checks if the oxidation state is the same as in dictionary,
        # 2. Takes appropriate constant, 3. Perform multiplication with atom No of this oxidation state
        if element.first_ox_state in ox_state_data and element.first_ox_state_at_no is not None:
          sum_dia_contr += ox_state_data[element.first_ox_state] * element.first_ox_state_at_no
        
        # I gave the possibility for the user to chose two different oxidation states if the molecules is more complicated.
        if element.second_ox_state in ox_state_data and element.second_ox_state_at_no is not None:
          sum_dia_contr += ox_state_data[element.second_ox_state] * element.second_ox_state_at_no

        # Analogous calculations as for oxidation states but here with ion 
        if element.first_ion_charge in ionic_data and element.first_ion_no is not None:
          sum_dia_contr += ionic_data[element.first_ion_charge] * element.first_ion_no

        # I also gave the possibility for the user to chose more then one ion type if molecule is more complex.
        if element.second_ion_charge in ionic_data and element.second_ion_no is not None:
          sum_dia_contr += ionic_data[element.second_ion_charge] * element.second_ion_no
          
  return sum_dia_contr
          



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







# def get_diamag_contr_for_element(element: dict):
#   """ TODO: Search diamag_const_atoms table to return proper diamag
#     for given input object """
  

#   el_const = diamag_const_atoms[element['C']]
#   print(el_const)



  
  
  #el_const_character = el_const[element['character']]
  #el_const_charge = el_const_character[element['charge']]
  
  #is_open_chain: bool = element['open_chain_atom_no'] > 0
  #is_ring: bool = element['ring_atom_no'] > 0
  #if is_ring:
  #  ...
  #if is_open_chain:
  #  ...
  
  #return ...

# def calc_diamag_contr(input_data: dict):
#   """ TODO: include open_chain / ring logic, not just 'total_atom_no' """
#   sum_dia_contr = 0
#   for element in input_data:
#     sum_dia_contr += get_diamag_contr_for_element(element=element) * element['total_atom_no']
  
#   return sum_dia_contr









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
