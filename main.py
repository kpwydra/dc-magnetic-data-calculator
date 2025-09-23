from diamag import calc_atoms_no
from diamag import calc_diamag_contr



# creating dictionary that comprise diamagnetic Pascal constants from
# all elements. Items from this dictionary will be called to calculate
# diamagnetic contribution of the molecule, based on its 
# chemical formula. Final formula: 
# type of atom * number of atoms * Pascal constant of the atom 

def main():
    formula = input('>')
    result = calc_atoms_no(formula=formula)
    print(result)
    sum_dia_contr = calc_diamag_contr(result=result)
    print(f'X(D) = {sum_dia_contr} cm^3/mol')



if __name__ == '__main__': # entry point, first execution step
    main()


