library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port(
        clk : in std_logic;
        reset : in std_logic;
        input_enable : in std_logic;
        input_end : in std_logic;
        input_err : in std_logic_vector(1 downto 0);
        input_data : in std_logic_vector(1 downto 0)
    );
end memory;    

architecture Behavioral of memory is
    component memory_controller is
    generic(
        WIDTH : integer := 8;
        DEPTH : integer := 16;
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
    end component;
    
    component reg_file is
    generic(
        WIDTH : integer := 8;
        DEPTH : integer := 16;
        DATA_WIDTH : integer := 2
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        input_clear : in std_logic;
        wr_en : in std_logic;
        w_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        w_addr_row  : in std_logic_vector(3 downto 0);
        w_data_col : in std_logic_vector(DATA_WIDTH-1 downto 0)    
    );
    end component;
    
    -- Internal signals
    signal wire_output_clear : std_logic;
    signal bus_output_mem_col : std_logic_vector(1 downto 0);
    signal bus_output_mem_row : std_logic_vector(3 downto 0);
    
begin
    MEM_CONTROLLER : memory_controller
    generic map(
        WIDTH => 8,
        DEPTH => 16,
        DATA_WIDTH => 2
    )
    port map(
        clk => clk,
        reset => reset,
        enable => input_enable,
        input_end => input_end,
        input_err => input_err,
        output_clear => wire_output_clear,
        output_mem_row => bus_output_mem_row,
        output_mem_col => bus_output_mem_col        
    );
    
    REGISTER_FILE : reg_file
        generic map(
        WIDTH => 8,
        DEPTH => 16,
        DATA_WIDTH => 2
    )
    port map(
        clk => clk,
        reset => reset,
        input_clear => wire_output_clear,
        wr_en => input_enable,
        w_data => input_data,
        w_addr_row => bus_output_mem_row,
        w_data_col => bus_output_mem_col
    );

end Behavioral;    