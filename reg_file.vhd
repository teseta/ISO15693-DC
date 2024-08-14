library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
    generic(
        WIDTH : integer := 8; -- number of bits
        DEPTH : integer := 16; -- number of address bits
        DATA_WIDTH : integer := 2
    );
    
    port(
        clk : in std_logic;
        reset : in std_logic;
        input_clear : in std_logic;
        wr_en : in std_logic;
        w_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        w_addr_row  : in std_logic_vector(3 downto 0);  --log2(depth)-1 = 16
        w_data_col : in std_logic_vector(DATA_WIDTH-1 downto 0)  -- word[7:6], word[5:4], word[3:2], word[1:0]
    );
end reg_file;
    
architecture Behavioral of reg_file is
    type reg_file_type is array (DEPTH-1 downto 0) of unsigned(WIDTH-1 downto 0);
    signal array_reg : reg_file_type;
begin        
    process(clk, reset)
    begin
        if reset = '1' then
            array_reg <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if input_clear = '1' then
                array_reg <= (others => (others => '0'));
            elsif wr_en = '1' then
                array_reg(to_integer(unsigned(w_addr_row)))(to_integer(unsigned(w_data_col)) * 2 + 1 downto to_integer(unsigned(w_data_col)) * 2) <= unsigned(w_data);
            end if;
        end if;
    end process;
end Behavioral;        

