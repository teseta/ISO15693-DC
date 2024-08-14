library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_flag_decoder is
    generic(
        N : integer := 16;
        TIMEUNIT : integer := 944 -- (bp / tclk) 
    );
    Port(
        clk, reset : in std_logic;
        pulse_in : in std_logic_vector(N-1 downto 0);
        pulse_out : out std_logic_vector(4 downto 0)
    );
end pulse_flag_decoder;

architecture Behavioral of pulse_flag_decoder is
    -- ONE MARGIN
    constant ONE_TOP : natural :=  TIMEUNIT * (29/20); --1.45
    constant ONE_BOTTOM : natural := TIMEUNIT * (11/20); --0.55
    
    -- TWO MARGIN
    constant TWO_TOP : natural := TIMEUNIT * (49/20); --2.45
    constant TWO_BOTTOM : natural := TIMEUNIT * (31/20); --1.55
    
    -- THREE MARGIN
    constant THREE_TOP : natural := TIMEUNIT * (69/20); --3.45
    constant THREE_BOTTOM : natural := TIMEUNIT * (51/20); --2.55
    
    -- FOUR MARGIN
    constant FOUR_TOP : natural := TIMEUNIT * (89/20); --4.45
    constant FOUR_BOTTOM : natural := TIMEUNIT * (71/20); --3.55
    
    -- FIVE MARGIN
    constant FIVE_TOP : natural := TIMEUNIT * (109/20); --5.45
    constant FIVE_BOTTOM : natural := TIMEUNIT * (91/20); --4.55
    
    -- SIX MARGIN
    constant SIX_TOP : natural := TIMEUNIT * (129/20); --6.45
    constant SIX_BOTTOM : natural := TIMEUNIT * (111/20); --5.55
    
    -- SEVEN MARGIN
    constant SEVEN_TOP : natural := TIMEUNIT * (149/20); --7.45
    constant SEVEN_BOTTOM : natural := TIMEUNIT * (131/20); --6.55
    
    -- EIGHT MARGIN    
    constant EIGHT_TOP : natural := TIMEUNIT * (169/20); --8.45
    constant EIGHT_BOTTOM : natural := TIMEUNIT * (151/20); --7.55

    -- NINE MARGIN
    constant NINE_TOP : natural := TIMEUNIT * (189/20); --9.45
    constant NINE_BOTTOM : natural := TIMEUNIT * (171/20); --8.55

    -- ELEVEN MARGIN
    constant ELEVEN_TOP : natural := TIMEUNIT * (229/20); --11.45
    constant ELEVEN_BOTTOM : natural := TIMEUNIT * (211/20); --10.55
    
    -- THIRTEENN
    constant THIRTEEN_TOP : natural := TIMEUNIT * (269/20); --13.45
    constant THIRTEEN_BOTTOM : natural := TIMEUNIT * (251/20); --12.55
    
    -- TIMEOUT
    constant TIMEOUT : natural := TIMEUNIT * 15; --15
    
    begin
            
    pulse_out <= "00001" when to_integer(unsigned(pulse_in)) >= ONE_BOTTOM and to_integer(unsigned(pulse_in)) <= ONE_TOP else -- 1U
                 "00010" when to_integer(unsigned(pulse_in)) >= TWO_BOTTOM and to_integer(unsigned(pulse_in)) <= TWO_TOP else -- 2U
                 "00011" when to_integer(unsigned(pulse_in)) >= THREE_BOTTOM and to_integer(unsigned(pulse_in)) <= THREE_TOP else -- 3U
                 "00100" when to_integer(unsigned(pulse_in)) >= FOUR_BOTTOM and to_integer(unsigned(pulse_in)) <= FOUR_TOP else -- 4U
                 "00101" when to_integer(unsigned(pulse_in)) >= FIVE_BOTTOM and to_integer(unsigned(pulse_in)) <= FIVE_TOP else -- 5U
                 "00110" when to_integer(unsigned(pulse_in)) >= SIX_BOTTOM and to_integer(unsigned(pulse_in)) <= SIX_TOP else -- 6U
                 "00111" when to_integer(unsigned(pulse_in)) >= SEVEN_BOTTOM and to_integer(unsigned(pulse_in)) <= SEVEN_TOP else --7U
                 "01000" when to_integer(unsigned(pulse_in)) >= EIGHT_BOTTOM and to_integer(unsigned(pulse_in)) <= EIGHT_TOP else --8U
                 "01001" when to_integer(unsigned(pulse_in)) >= NINE_BOTTOM and to_integer(unsigned(pulse_in)) <= NINE_TOP else --9U
                 "01011" when to_integer(unsigned(pulse_in)) >= ELEVEN_BOTTOM and to_integer(unsigned(pulse_in)) <= ELEVEN_TOP else -- 11U
                 "01101" when to_integer(unsigned(pulse_in)) >= THIRTEEN_BOTTOM and to_integer(unsigned(pulse_in)) <= THIRTEEN_TOP else --13U
                 "11111" when to_integer(unsigned(pulse_in)) >= TIMEOUT;
end Behavioral;
