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
        'total_atom_no': 66,
        'aliphatic_atom_no': 36,
        'aromatic_atom_no': 30,
        'ox_state': '+4',
        'character': 'covalent', # options: covalent / ionic
      },
      { # Element 2
        'name': 'H',
        'total_atom_no': 30,
        'aliphatic_atom_no': 30,
        'aromatic_atom_no': 0,
        'ox_state': '-1',
        'character': 'ionic', # options: covalent / ionic
      },
    ]
    
    sum_dia_contr = calc_diamag_contr(input_data=input_data)
    print(f'X(D) = {sum_dia_contr} cm^3/mol')

if __name__ == '__main__': # entry point, first execution step
    main()
