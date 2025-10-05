plan1 = """
N:1
    =C
        -H
        -C
            -Cl[-]
            =C
                -H
                -C
                    -H
                    =C:1
                        -Hg[II]
                            -C
                                -H2
                                -N
                                    -H2
"""

plan2 = """
N:1
    =C
        -H
        -C
            -Cl
            =C
                -H
                -C
                    -H
                    =C:1
                        -Hg[II]
                            -C
                                -H2
                                -N
                                    -H2
"""

plan = """
N:1 =C( H,
        C( Cl,
            =C( H,
                C( H,
                    =C:1( Hg[II]( C(H2, N(H2)) ) )
                )
            )
        )
    )
"""

ions = ["Hg[2+]", "Cl[-]", "F[-]"]

bond_types = {"1": "="}
