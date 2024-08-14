library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector_v2 is
    generic(
        N : integer := 16
    );
    Port( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        input_value : in STD_LOGIC_VECTOR (N-1 downto 0);
        output_value : out STD_LOGIC_VECTOR (N-1 downto 0);
        output_enable : out STD_LOGIC
    );
end edge_detector_v2;

architecture Behavioral of edge_detector_v2 is

signal last_value_reg, last_value_next: std_logic_vector (15 downto 0);
signal output_enable_reg, output_enable_next: std_logic;
signal output_value_reg, output_value_next: std_logic_vector (15 downto 0);

begin

--register process
process(clk, reset)
begin
    if reset = '1' then
        last_value_reg <= (others=>'0');
        output_enable_reg <= '0';
        output_value_reg <= (others=>'0');
    elsif rising_edge(clk) then
        last_value_reg <= last_value_next;
        output_enable_reg <= output_enable_next;
        output_value_reg <= output_value_next;        
    end if;
end process;

--next state logic
last_value_next <= input_value;
output_value_next <= last_value_reg;
output_enable_next <= '1' when ((input_value = "0000000000000000" and last_value_reg /= "0000000000000000") or input_value = "1111111111111111") else '0';

--output logic
output_value <= output_value_reg;
output_enable <= output_enable_reg;
end Behavioral;
