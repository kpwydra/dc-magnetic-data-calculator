from diamag import calc_diamag_contr
from tests.unit.test_data import MOLECULES_DATA


def test_calc_diamag_contr():
    """Verifies diamag calculations are correct."""

    for molecule in MOLECULES_DATA:
        result = calc_diamag_contr(molecule["elements"])
        assert molecule["diamag"] == round(result, 2)
