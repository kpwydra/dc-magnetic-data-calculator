#from diamag import calc_atoms_no
from diamag import calc_diamag_contr
from element import Element

input_data = [
  Element(symbol='C', total=20, ring=12, chain=8),
  Element(symbol='H', total=25, chain=25),
  Element(symbol='N', total=1, ring=1),
  Element(symbol='Cl', total=1, first_ion_charge='-1', first_ion_no=1),
]

def main():
  result = calc_diamag_contr(input_data)
  print(f' X(D) = {result} cm^3/mol')
  assert round(result, 2) == -224.14


#sum_dia_contr = calc_diamag_contr(input_data=input_data)
#print(f'X(D) = {sum_dia_contr} cm^3/mol')

if __name__ == '__main__': # entry point, first execution step
    main()
