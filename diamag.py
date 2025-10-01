"""
unit: 10^(-6) cm^3/mol
This dictionary represents the diamagnetic constants for elements in
different bonding/oxidation_state/ionic_charge scenarios. Here's a breakdown of the values:
"""
# TODO: Move to separate file.
diamag_const_atoms = {
    "C": {
        "covalent": {
            "ring": -6.24,
            "open_chain": -6.0,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+4": -0.1,
            },
        },
    },
    "H": {
        "covalent": {
            "ring": None,
            "open_chain": -2.93,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": 0,
                "-1": -5.7,
            },
        },
    },
    "N": {
        "covalent": {
            "ring": -4.61,
            "open_chain": -5.57,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+5": -0.1,
            },
        },
    },
    "Ag": {
        "covalent": {
            "ring": None,
            "open_chain": -31.0,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": -28,
                "+2": -24,  # uncetrain value according to the article (DOI: 10.1021/ed085p532)
            },
        },
    },
    "Al": {
        "covalent": {
            "ring": None,
            "open_chain": -13.0,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -2,
            },
        },
    },
    "As": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {
                "(III)": -20.9,
                "(V)": -43.0,
            },
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -9,  # uncetrain value according to the article (DOI: 10.1021/ed085p532)
                "+5": -6,
            },
        },
    },
    "Au": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": -40,  # uncetrain value according to the article (DOI: 10.1021/ed085p532)
                "+3": -32,
            },
        },
    },
    "B": {
        "covalent": {
            "ring": None,
            "open_chain": -7.0,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -0.2,
            },
        },
    },
    "Ba": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -26.5,
            },
        },
    },
    "Be": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -0.4,
            },
        },
    },
    "Bi": {
        "covalent": {
            "ring": None,
            "open_chain": -192.0,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -25,  # uncetrain value according to the article (DOI: 10.1021/ed085p532)
                "+5": -23,
            },
        },
    },
    "Br": {
        "covalent": {
            "ring": None,
            "open_chain": -30.6,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "-1": -34.6,
                "+5": -6,
            },
        },
    },
    "Ca": {
        "covalent": {
            "ring": None,
            "open_chain": -15.9,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -10.4,
            },
        },
    },
    "Cd": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -24,
            },
        },
    },
    "Ce": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -20,
                "+4": -17,
            },
        },
    },
    "Cl": {
        "covalent": {
            "ring": None,
            "open_chain": -20.1,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "-1": -23.4,
                "+5": -2,
            },
        },
    },
    "Co": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -12,
                "+3": -10,
            },
        },
    },
    "Cr": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -15,
                "+3": -11,
                "+4": -8,
                "+5": -5,
                "+6": -3,
            },
        },
    },
    "Cs": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": -35.0,
            },
        },
    },
    "Cu": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": -12,
                "+2": -11,
            },
        },
    },
    "Dy": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -19,
            },
        },
    },
    "Er": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -18,
            },
        },
    },
    "Eu": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -22,
                "+3": -20,
            },
        },
    },
    "F": {
        "covalent": {
            "ring": None,
            "open_chain": -6.3,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "-1": -9.1,
            },
        },
    },
    "Fe": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -13,
                "+3": -10,
            },
        },
    },
    "Ga": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -8,
            },
        },
    },
    "Ge": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+4": -7,
            },
        },
    },
    "Gd": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -20,
            },
        },
    },
    "Hf": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+4": -16,
            },
        },
    },
    "Hg": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {
                "(II)": -33.0,
            },
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+2": -40.0,
            },
        },
    },
    "Ho": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -19,
            },
        },
    },
    "I": {
        "covalent": {
            "ring": None,
            "open_chain": -44.6,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "-1": -50.6,
                "+5": -12,
                "+7": -10,
            },
        },
    },
    "In": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+3": -19,
            },
        },
    },
    "Ir": {
        "covalent": {
            "ring": None,
            "open_chain": None,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": -50,
                "+2": -42,
                "+3": -35,
                "+4": -29,
                "+5": -20,
            },
        },
    },
    "K": {
        "covalent": {
            "ring": None,
            "open_chain": -18.5,
            "ox_state": {},
        },
        "ionic": {
            "ring": None,
            "open_chain": None,
            "charge": {
                "+1": -14.9,
            },
        },
    },
}


def calc_diamag_contr(input_data: list):
    sum_dia_contr = 0

    for element in input_data:

        if element.symbol in diamag_const_atoms:
            # retrieve const data
            covalent_data = diamag_const_atoms[element.symbol]["covalent"]
            ionic_data = diamag_const_atoms[element.symbol]["ionic"]["charge"]
            ox_state_data = diamag_const_atoms[element.symbol]["covalent"]["ox_state"]

            # for given element it takes ring constant and multiplies it with related atom No of the element
            if element.ring is not None and covalent_data["ring"] is not None:
                sum_dia_contr += covalent_data["ring"] * element.ring

            # for given element it takes chain constant and multiplies it with related atom No of the element
            if (
                element.open_chain is not None
                and covalent_data["open_chain"] is not None
            ):
                sum_dia_contr += covalent_data["open_chain"] * element.open_chain

            # calculate diamag contrib for given oxidation state data
            for state, atoms in element.ox_states.items():
                if state in ox_state_data.keys(): # TODO: use .get() instead, make it oneliner
                    sum_dia_contr += ox_state_data[state] * atoms

            # calculate diamag contrib for given ionic data
            for charge, atoms in element.ions.items():
                if charge in ionic_data.keys(): # TODO: use .get() instead, make it oneliner
                    sum_dia_contr += ionic_data[charge] * atoms

    return sum_dia_contr


def calc_atoms_no(formula: str):
    """
    Old version of input structure
    """
    input_data = {}

    key, value = "", ""
    for i in range(len(formula)):
        curr = formula[i]

        if i + 1 < len(formula):
            next = formula[i + 1]
            if curr.isalpha() and next.isalpha():
                key += curr
            elif curr.isalpha() and next.isdigit():
                key += curr
            elif curr.isdigit() and next.isdigit():
                value += curr
            elif curr.isdigit() and next.isalpha():
                value += curr
                input_data[key.capitalize()] = int(value)
                key, value = "", ""
        else:
            value += curr
            input_data[key.capitalize()] = int(value)

    return input_data
