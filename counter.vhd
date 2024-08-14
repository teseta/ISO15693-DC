library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic( 
        N : integer := 16
    );
    port(
        clk, reset, en : in std_logic;
        q : out std_logic_vector(N-1 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal r_reg : unsigned(N-1 downto 0);
    signal r_next : unsigned(N-1 downto 0);
 begin
    -- register
    process(clk, reset)
    begin
        if (reset = '1') then
            r_reg <= (others => '0');
        elsif (rising_edge(clk)) then
            if (en = '1') then
                r_reg <= r_next;
            else
                r_reg <= (others => '0');
            end if;
        end if;
    end process;
    
    -- next_state logic
    r_next <= r_reg + 1;
    
    -- output logic
    q <= std_logic_vector(r_reg);
    
end Behavioral;
