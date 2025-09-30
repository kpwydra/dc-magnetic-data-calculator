
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
        - Element("C", total=7, ring=3, open_chain=4, ox_states={"+4": 7})
        - Element("Fe", total=2, ox_states={"+3": 1, "+2": 1})
      """
      self.symbol = symbol
      self.total = total
      self.ring = ring
      self.open_chain = open_chain
      self.ions = ions if ions is not None else {}
      self.ox_states = ox_states if ox_states else {}
