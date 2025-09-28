from diamag import calc_atoms_no
from diamag import calc_diamag_contr

"""
creating dictionary that comprise diamagnetic Pascal constants from
all elements. Items from this dictionary will be called to calculate
diamagnetic contribution of the molecule, based on its 
chemical formula. Final formula: 
type of atom * number of atoms * Pascal constant of the atom 
"""

def main():
    # This structure was not elastic enough ('dict' is more elastic than 'str')
    # result = calc_atoms_no(formula="C60H20cl40")
    # print(result)
    
    input_data = [
      { # Element 1
        'name': 'C',
        'total_atom_no': 20,
          'covalent_atom_no': 20,
            'ring_atom_no': 12,
            'open_chain_atom_no': 8,
            'ox_state': {
                'I': 0,
                'II': 0,
                'III': 0,
                'IV': 0,
                'V': 0,
            }
        'ionic_atom_no': 0,
          'charge': {
              '+8': 0,
              '+7': 0,
              '+6': 0,
              '+5': 0,
              '+4': 0,
              '+3': 0,
              '+2': 0,
              '+1': 0,
              '-1': 0,
              '-2': 0,
          }
        
      },
      { # Element 2
        'name': 'H',
        'total_atom_no': 25,
          'covalent_atom_no': 25,
            'ring_atom_no': 0,
            'open_chain_atom_no': 25,
            'ox_state': {
                'I': 0,
                'II': 0,
                'III': 0,
                'IV': 0,
                'V': 0,
            }
        'ionic_atom_no': 0,
          'charge': {
              '+8': 0,
              '+7': 0,
              '+6': 0,
              '+5': 0,
              '+4': 0,
              '+3': 0,
              '+2': 0,
              '+1': 0,
              '-1': 0,
              '-2': 0,
          },
      },
      { # Element 3
        'name': 'N',
        'total_atom_no': 1,
          'covalent_atom_no': 1,
            'ring_atom_no': 1,
            'open_chain_atom_no': 0,
            'ox_state': {
                'I': 0,
                'II': 0,
                'III': 0,
                'IV': 0,
                'V': 0,
            }
        'ionic_atom_no': 0,
          'charge': {
              '+8': 0,
              '+7': 0,
              '+6': 0,
              '+5': 0,
              '+4': 0,
              '+3': 0,
              '+2': 0,
              '+1': 0,
              '-1': 0,
              '-2': 0,
          },
      },
    ]
    
    sum_dia_contr = calc_diamag_contr(input_data=input_data)
    print(f'X(D) = {sum_dia_contr} cm^3/mol')

if __name__ == '__main__': # entry point, first execution step
    main()
