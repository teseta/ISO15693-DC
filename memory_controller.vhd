library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_controller is
    generic( 
        WIDTH : integer := 8; -- number of bits
        DEPTH : integer := 16; -- number of address bits
        DATA_WIDTH : integer := 2
    );
    port(
        clk, reset, enable : in std_logic;
        input_end : in std_logic;
        input_err : in std_logic_vector(1 downto 0);
        output_clear : out std_logic;
        output_mem_row : out std_logic_vector(3 downto 0); --log2(depth)-1 = 16
        output_mem_col : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end memory_controller;

architecture Behavioral of memory_controller is
    signal row_reg : unsigned(3 downto 0); --log2(depth)-1 = 16
    signal row_next : unsigned(3 downto 0); --log2(depth)-1 = 16
    signal col_reg : unsigned(DATA_WIDTH-1 downto 0);
    signal col_next : unsigned(DATA_WIDTH-1 downto 0);
begin
   process(clk, reset)
   begin
    if reset = '1' then
        row_reg <= (others => '0');
        col_reg <= (others => '0');
    elsif rising_edge(clk) then
        if input_end = '1' or input_err /= "00" then -- clear sincrono.
            row_reg <= (others => '0');
            col_reg <= (others => '0');            
        elsif enable = '1' then
            col_reg <= col_next;
            if col_reg = X"03" then
                row_reg <= row_next;
            end if;
        end if;
    end if;
   end process; 
   
   -- next state logic
   row_next <= row_reg + 1;
   col_next <= col_reg + 1;
   
   -- output logic
   output_mem_row <= std_logic_vector(row_reg);
   output_mem_col <= std_logic_vector(col_reg);
   output_clear <= '1' when input_end = '1' or input_err /= "00" else '0';
   
end Behavioral;