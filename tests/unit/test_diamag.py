from diamag import calc_diamag_contr
from tests.unit.test_data import CALC_DIAMAG_CONTR_TEST_CASES


def test_calc_diamag_contr():
    """Verifies diamag calculations are correct."""

    for case in CALC_DIAMAG_CONTR_TEST_CASES:
        result = calc_diamag_contr(case["data"])
        assert case["expected"] == round(result, 2)
