from molecule_builder import Element, MoleculeBuilder

mol = (
    MoleculeBuilder()
    .bind_nodes(
        n1 := Element("C", 3),
        n2=[
            c2 := Element("C", 4).bind("="),
            Element("Cl", 7).bind("-"),
        ],
    )
    .bind_nodes(
        n1=c2,
        n2=[
            Element("H", 1).bind("-"),
            Element("N", 1).bind("="),
        ],
    )
)
