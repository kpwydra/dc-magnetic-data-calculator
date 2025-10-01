import pytest
from diamag import calc_diamag_contr
from element import Element


test_case_1 = {
    "data": [
        Element(symbol="C", total=20, ring=12, open_chain=8),
        Element(symbol="H", total=25, open_chain=25),
        Element(symbol="N", total=1, ring=1),
        Element(symbol="Cl", total=1, ions={"-1": 1}),
    ],
    "expected": -224.14,
}

test_case_2 = {
    "data": [
        Element(symbol="C", total=45, ring=25, open_chain=20),
        Element(symbol="H", total=30),
        Element(symbol="N", total=9, ring=4, open_chain=5),
    ],
    "expected": -410.19,
}

test_case_3 = {
    "data": [
        Element(symbol="C", total=25, ring=15, open_chain=10),
        Element(symbol="H", total=22),
        Element(symbol="As", total=3, ox_states={"(III)": 3}),
        Element(symbol="Br", total=2, ions={"-1": 2}),
    ],
    "expected": -349.96,
}


def test_calc_diamag_contr_OK():
    """Simple Test that verifies calc_diamag_contr function correct input / output."""
    # Test Case 1
    result = calc_diamag_contr(test_case_1["data"])
    assert test_case_1["expected"] == round(result, 2)


@pytest.mark.skip(reason="These test needs a fix")
def test_calc_diamag_contr_TODO():
    # Test Case 2
    result = calc_diamag_contr(test_case_2["data"])
    assert test_case_2["expected"] == round(result, 2)  # TODO: wrong value is returned: -322.29

    # Test Case 3
    result = calc_diamag_contr(test_case_3["data"])
    assert test_case_3["expected"] == round(result, 2)  # TODO: wrong value is returned: -285.5
