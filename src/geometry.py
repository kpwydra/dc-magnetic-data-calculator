from dataclasses import dataclass


@dataclass
class Point:
    x: int
    y: int


@dataclass
class Node(Point):
    radius: float
    color: str

    def __repr__(self):
        # TODO: is it a good idea to let a node object print directly on canvas?
        return super().__repr__()


@dataclass
class Edge:
    p1: Point
    p2: Point
