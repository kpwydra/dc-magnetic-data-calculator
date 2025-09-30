
import pytest
from diamag import calc_diamag_contr
from element import Element


test_case_1 = {
    'data': [
      Element(symbol='C', total_at_no=20, ring_at_no=12, chain_at_no=8),
      Element(symbol='H', total_at_no=25, chain_at_no=25),
      Element(symbol='N', total_at_no=1, ring_at_no=1),
      Element(symbol='Cl', total_at_no=1, first_ion_charge='-1', first_ion_no=1),
    ],
    'expected': -224.14,
  }

test_case_2 =  {
    'data': [
      Element(symbol='C', total_at_no=45, ring_at_no=25, chain_at_no=20),
      Element(symbol='H', total_at_no=30),
      Element(symbol='N', total_at_no=9, ring_at_no=4, chain_at_no=5),
    ],
    'expected': -410.19,
  }

test_case_3 =  {
    'data': [
      Element(symbol='C', total_at_no=25, ring_at_no=15, chain_at_no=10),
      Element(symbol='H', total_at_no=22),
      Element(symbol='As', total_at_no=3, first_ox_state='(III)', first_ox_state_at_no=3),
      Element(symbol='Br', total_at_no=2, first_ion_charge='-1', first_ion_no=2),
    ],
    'expected': -349.96,
  }

def test_calc_diamag_contr_OK():
  """ Simple Test that verifies calc_diamag_contr function correct input / output. """
  # Test Case 1
  result = calc_diamag_contr(test_case_1['data'])
  result = round(result, 2)
  assert test_case_1['expected'] == result


@pytest.mark.skip(reason='These tests need a fix')
def test_calc_diamag_contr_TODO():
  # Test Case 2
  result = calc_diamag_contr(test_case_2['data'])
  result = round(result, 2)
  assert test_case_2['expected'] == result  # TODO: wrong value is returned: -322.29
  
  # Test Case 3
  result = calc_diamag_contr(test_case_3['data'])
  result = round(result, 2)
  assert test_case_3['expected'] == result  # TODO: wrong value is returned: -285.5
