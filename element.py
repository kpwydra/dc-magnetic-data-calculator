class Element:
    def __init__(self, 
                 symbol: str, 
                 total_at_no: int, 
                 ring_at_no: int=None, 
                 chain_at_no: int=None,
                 first_ox_state: str=None,
                 first_ox_state_at_no: int=None, 
                 second_ox_state: str=None,
                 second_ox_state_at_no: int=None, 
                 first_ion_charge: str=None,
                 first_ion_no: int=None,
                 second_ion_charge: str=None,
                 second_ion_no: int=None):
        self.symbol = symbol
        self.total_at_no = total_at_no
        self.ring_at_no = ring_at_no
        self.chain_at_no = chain_at_no
        self.first_ox_state = first_ox_state
        self.first_ox_state_at_no = first_ox_state_at_no
        self.second_ox_state = second_ox_state
        self.second_ox_state_at_no = second_ox_state_at_no
        self.first_ion_charge = first_ion_charge
        self.first_ion_no = first_ion_no
        self.second_ion_charge = second_ion_charge
        self.second_ion_no = second_ion_no