from dataclasses import dataclass

from canvas import Renderer


@dataclass
class Point:
    # x: int
    # y: int
    ...


@dataclass
class Node(Point):

    # radius: int = None
    # color: str = None
    ...


@dataclass
class Edge:
    # p1: Point = None
    # p2: Point = None
    ...
