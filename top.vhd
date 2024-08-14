library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
    Port(
        clk     : in std_logic;
        reset   : in std_logic;
        data_in : in std_logic;
        output_data : out std_logic_vector(1 downto 0);
        output_valid : out std_logic;
        output_end_tx : out std_logic;
        output_err : out std_logic_vector(1 downto 0)
    );
end top;

architecture Behavioral of top is
    component counter is
    generic(
        N : integer := 16
    );
    Port(
        clk : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        q : out std_logic_vector(N-1 downto 0)
    );   
    end component;  
    
    component edge_detector_v2 is
    generic(
        N : integer := 16
    );
    Port(
        clk : in std_logic;
        reset : in std_logic;
        input_value : in std_logic_vector(15 downto 0);
        output_value: out std_logic_vector(15 downto 0);
        output_enable : out std_logic        
    );
    end component;
    
    component pulse_flag_decoder is
    generic(
        N : integer := 16;
        TIMEUNIT : integer := 944 -- (bp / tclk) 
    );
    Port(
        clk, reset : in std_logic;
        pulse_in : in std_logic_vector(N-1 downto 0);
        pulse_out : out std_logic_vector(4 downto 0)
    );
    end component;
    
    component coding_detector is
    Port(
        clk : in std_logic;
        reset : in std_logic;
        input_value: in std_logic_vector(4 downto 0);
        input_enable : in std_logic;
        output_data : out std_logic_vector(1 downto 0);
        output_valid : out std_logic;
        output_end_tx : out std_logic;
        output_err : out std_logic_vector -- "01" TIMEOUT -- "10" UNKNOWN ERROR 
    );
    end component;
    
    -- Internal signals;
    signal count_out : std_logic_vector(15 downto 0);
    signal edge_value_out : std_logic_vector(15 downto 0);
    
    signal enable_fsm : std_logic;
    signal value_fsm : std_logic_vector(4 downto 0);
    
begin
    COUNTER_T : counter
    generic map(
        N => 16
    )
    port map(
        clk => clk,
        reset => reset,
        en => data_in,
        q => count_out
    );
    
    EDGE_DETECTOR_T : edge_detector_v2
    generic map(
        N => 16
    )
     port map(
        clk => clk,
        reset => reset,
        input_value => count_out,
        output_value => edge_value_out,
        output_enable => enable_fsm
     );
     
     PULSE_FLAG_DECODER_T : pulse_flag_decoder
     generic map(
        N => 16,
        TIMEUNIT => 944
     )
     port map(
        clk => clk,
        reset => reset,
        pulse_in => edge_value_out,
        pulse_out => value_fsm
     );
     
     CODING_DETECTOR_T : coding_detector
     port map(
        clk => clk,
        reset => reset,
        input_enable => enable_fsm,
        input_value => value_fsm,
        output_data => output_data,
        output_valid => output_valid,
        output_end_tx => output_end_tx,
        output_err => output_err
     );

end Behavioral;    
