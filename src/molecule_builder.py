from __future__ import annotations

from dataclasses import dataclass

from geometry import Edge, Node


@dataclass
class Bond(Edge):
    """Think of a bond as an edge between a pair of any comb of 2 atoms or molecules."""

    type: str = "-"  # options: "-", "=", "#", ":", "C=O", "C≡N"
    n1: Node = None
    n2: Node = None


@dataclass
class Element(Node):
    """Element class."""

    symbol: str = "H"
    atoms_total: int = 1

    def bind(self, type: str = "-") -> Element:
        self.bond = Bond(type=type, n1=self)
        return self


class Molecule(Node):
    """Moleculeecule class. Contains graph-like relations to other atoms or molecules."""

    def __init__(self, nodes: list[Node], bonds: list[Bond]):
        self.nodes = nodes
        self.bonds = bonds


class MoleculeBuilder:
    """Allows building complex molecules like lego."""

    def __init__(self):
        self._nodes: list[Node] = []
        self._bonds: list[Bond] = []

    def bind(
        self, n1: Node | list[Node], n2: Node | list[Node], type="-", relation="1-1"
    ) -> "MoleculeBuilder":
        """bind bond(s) between nodes."""
        n1_list = n1 if isinstance(n1, list) else [n1]
        n2_list = n2 if isinstance(n2, list) else [n2]

        # bind unique nodes
        for node in n1_list + n2_list:
            if node not in self._nodes:
                self._nodes.append(node)

        # bind bonds
        if relation == "1-1":
            self._bonds.append(Bond(type=type, n1=n1_list[0], n2=n2_list[0]))
        elif relation == "1-many":
            for node in n2_list:
                self._bonds.append(Bond(type=type, n1=n1_list[0], n2=node))
        elif relation == "all-all":
            for a in n1_list:
                for b in n2_list:
                    self._bonds.append(Bond(type=type, n1=a, n2=b))
        else:
            raise ValueError(f"Unknown relation mode: {relation}")

        return self

    def build(self) -> Molecule:
        return Molecule(nodes=self._nodes, bonds=self._bonds)


mol = (
    MoleculeBuilder()
    .bind(c1 := Element("C"), c2 := Element("C"), type="=")
    .bind(c1, cl1 := Element("Cl"))
    .bind(c1, c3 := Element("C"))
    .bind(c3, h1 := Element("H"))
    .bind(c3, n1 := Element("N"), type="=")
    .bind(n1, c4 := Element("N"))
    .bind(c4, c5 := Element("N"))
    .bind(c5, h2 := Element("H"))
    .bind(c5, h3 := Element("H"))
    .bind(c4, hg := Element("Hg"))
    .bind(hg, c6 := Element("H"))
    .bind(c6, h4_5 := Element("H", 2), relation="1-many")
    .bind(c6, n2 := Element("N"))
    .bind(n2, h6_7 := Element("H", 2), relation="1-many")
)
# But h4_5 is a single Element instance with total=2. So your code creates one bond, not two.
x = 1
