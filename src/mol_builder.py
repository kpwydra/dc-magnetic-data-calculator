from __future__ import annotations
from dataclasses import dataclass

from src.geometry import Edge, Node


@dataclass
class A(Node):
    """Atom class."""

    symbol: str


@dataclass
class Bond(Edge):
    """Think of a bond as an edge between a pair of any comb of 2 atoms or molecules."""

    type: str = "-"  # options: "-", "=", "#", ":", "C=O", "C≡N"
    n1: Node = None
    n2: Node = None


class Mol(Node):
    """Molecule class. Contains graph-like relations to other atoms or molecules."""

    nodes: list[Node]
    bonds: list[Edge]


# --- builder ---
class MolBuilder:
    """Allows building complex molecules like lego."""

    def __init__(self):
        self._nodes: list[Node] = []
        self._edges: list[Bond] = []

    def bind_nodes(
        self, n1: Node | list[Node], n2: Node | list[Node], type="-", relation="1-1"
    ) -> Bond:
        """
        @relation: options: 1-1, 1-many, all-all
        """
        bond = Bond(n1=n1, n2=n2, type=type)
        self._edges.append(bond)

        return bond

    def build(self) -> Mol:

        return Mol(nodes=self._nodes, edges=self._edges)
