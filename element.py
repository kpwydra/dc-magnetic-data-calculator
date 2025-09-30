
class Element:
  def __init__(
    self, 
    symbol: str, 
    total: int = None, 
    ring: int = None, 
    open_chain: int = None,
    ions: dict = None,
    ox_states: dict = None,
    ):
      """ Examples:
        - Element("C", total=7, ring=3, open_chain=4, ox_states={"(IV)": 7})
        - Element(symbol='As', total=3, ox_states={'(III)': 3})
      """
      self.symbol = symbol
      self.total = total
      self.ring = ring
      self.open_chain = open_chain
      self.ions = ions if ions is not None else {}
      self.ox_states = ox_states if ox_states else {}
