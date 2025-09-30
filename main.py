from diamag import calc_diamag_contr
from element import Element


def main():
  input_data = [
    Element(symbol='C', total=45, ring=25, open_chain=20),
    Element(symbol='H', total=30),
    Element(symbol='N', total=9, ring=4, open_chain=5),
  ]

  result = calc_diamag_contr(input_data)
  print(f' X(D) = {result} cm^3/mol')
  
  mydict = {
  'some_key': 'some value',
  'another_key': 0.1,
  'yet_another_key': ['yet', 'another', 'value'],
  }
  x = mydict.get('i_dont_exist', 'default value')
  y = mydict.get('some_key', 'default value')
  print(f'x is: "{x}", y is: "{y}"')


if __name__ == '__main__': # entry point, first execution step
    main()
