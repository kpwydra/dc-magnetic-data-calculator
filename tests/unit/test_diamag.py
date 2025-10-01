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
    "expected": -224.4,
}

test_case_2 = {
    "data": [
        Element(symbol="C", total=45, ring=25, open_chain=20),
        Element(symbol="H", total=30, open_chain=30),
        Element(symbol="N", total=9, ring=4, open_chain=5),
    ],
    "expected": -410.19,
}

test_case_3 = {
    "data": [
        Element(symbol="C", total=25, ring=15, open_chain=10),
        Element(symbol="H", total=22, open_chain=22),
        Element(symbol="As", total=3, ox_states={"(III)": 3}),
        Element(symbol="Br", total=2, ions={"-1": 2}),
    ],
    "expected": -349.96,
}

test_corner_case_1 = {
    "data": [
        Element(symbol="B", total=10, open_chain=8, ions={"+3": 2}),
        Element(symbol="As", total=5, ox_states={"(III)": 2}, ions={"+3": 3}),
    ],
    "expected": -125.20,
}


def test_calc_diamag_contr():
    """Simple Test that verifies calc_diamag_contr function correct input / output."""
    # TODO: add for each loop instead of three variables (list of dictionaries)
    result = calc_diamag_contr(test_case_1["data"])
    assert test_case_1["expected"] == round(result, 2)

    result = calc_diamag_contr(test_case_2["data"])
    assert test_case_2["expected"] == round(result, 2)

    result = calc_diamag_contr(test_case_3["data"])
    assert test_case_3["expected"] == round(result, 2)


def test_calc_diamag_contr_corners():
    result = calc_diamag_contr(test_corner_case_1["data"])
    assert test_corner_case_1["expected"] == round(result, 2)
