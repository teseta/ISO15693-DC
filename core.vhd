library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity core is
    port(
        clk : in std_logic;
        reset : in std_logic;
        cmd : in std_logic
    );
end core;

architecture Behavioral of core is
    component top is
        port(
            clk         : in std_logic;
            reset       : in std_logic;
            data_in     : in std_logic;
            output_data : out std_logic_vector(1 downto 0);
            output_valid: out std_logic;
            output_end_tx: out std_logic;
            output_err  : out std_logic_vector(1 downto 0)
        );
    end component;
    
    component memory is
        port(
            clk         : in std_logic;
            reset       : in std_logic;
            input_enable: in std_logic;
            input_end   : in std_logic;
            input_err   : in std_logic_vector(1 downto 0);
            input_data  : in std_logic_vector(1 downto 0)    
        );
    end component;
    
    -- Señales internas
    signal bus_data     : std_logic_vector(1 downto 0);
    signal wire_enable  : std_logic;
    signal wire_end_tx  : std_logic;
    signal bus_err     : std_logic_vector(1 downto 0);
    
begin
    -- Instanciación de los componentes
    TOP_T : top
    port map(
        clk           => clk,
        reset         => reset,
        data_in       => cmd,
        output_data   => bus_data,
        output_valid  => wire_enable,
        output_end_tx => wire_end_tx,
        output_err    => bus_err
    );
    
    MEM_T : memory
    port map(
        clk           => clk,
        reset         => reset,
        input_enable  => wire_enable,
        input_end     => wire_end_tx,
        input_err     => bus_err,
        input_data    => bus_data
    );

end Behavioral;
