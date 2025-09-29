#from diamag import calc_atoms_no
from diamag import calc_diamag_contr
from element import Element

input_data = [
  Element(symbol='C', total_at_no=20, ring_at_no=12, chain_at_no=8),
  Element(symbol='H', total_at_no=25, chain_at_no=25),
  Element(symbol='N', total_at_no=1, ring_at_no=1),
  Element(symbol='Cl', total_at_no=1, first_ion_charge='-1', first_ion_no=1),
]

def main():
  print(calc_diamag_contr(input_data))






    
#sum_dia_contr = calc_diamag_contr(input_data=input_data)
#print(f'X(D) = {sum_dia_contr} cm^3/mol')

if __name__ == '__main__': # entry point, first execution step
    main()
