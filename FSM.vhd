library ieee;
use ieee.std_logic_1164.all;

entity coding_detector is
    port(
        clk, reset : in std_logic;
        input_value: in std_logic_vector(4 downto 0);
        input_enable : in std_logic;
        output_data : out std_logic_vector(1 downto 0);
        output_valid : out std_logic;
        output_end_tx : out std_logic;
        output_err : out std_logic_vector(1 downto 0) -- "01" TIMEOUT -- "10" UNKNOWN ERROR
    );
end coding_detector;

architecture fsm_arch of coding_detector is
    type state_type is (idle, sof, zero_st, one_st, two_st, three_st, eof);
    signal state_reg, state_next : state_type;
    
    signal output_data_reg : std_logic_vector(1 downto 0);
    signal output_data_next : std_logic_vector(1 downto 0);
    
    signal output_valid_reg : std_logic := '0';
    signal output_valid_next : std_Logic := '0';
    
    signal output_end_tx_reg : std_logic := '0';
    signal output_end_tx_next : std_logic := '0';
    
    signal output_err_reg : std_logic_vector(1 downto 0) := (others => '0');
    signal output_err_next : std_logic_vector(1 downto 0) := (others => '0');
    
begin
    -- signal process
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
            output_data_reg <= (others => '0');
            output_err_reg <= (others => '0');
            output_valid_reg <= '0';
            output_end_tx_reg <= '0';
        elsif rising_edge(clk) then
            state_reg <= state_next;
            output_data_reg <= output_data_next; 
            output_valid_reg <= output_valid_next;
            output_end_tx_reg <= output_end_tx_next;
            output_err_reg <= output_err_next;
        end if;
    end process;
    
    --next state logic
    process(state_reg, input_value, input_enable, output_data_reg, output_valid_reg, output_end_tx_reg, output_err_reg)
        begin
            -- default values (todas las salidas?)
            state_next <= state_reg;
            output_valid_next <= output_valid_reg;
            output_end_tx_next <= output_end_tx_reg;
            output_err_next <= output_err_reg;
            output_data_next <= output_data_reg;
            
            case state_reg is
            when idle =>
                output_end_tx_next <= '0';
                if input_enable = '1' and input_value = "00100" then -- 4
                    state_next <= sof;
                end if;
                    
            when sof =>
                output_valid_next <= '0';
                if input_enable = '1' then
                    case input_value is
                        when "00011" => -- 3
                            state_next <= zero_st;
                            output_valid_next <= '1';
                            output_data_next <= "00";
                        when "00101" => -- 5
                            state_next <= one_st;
                            output_valid_next <= '1';
                            output_data_next <= "01";                 
                        when "00111" => -- 7
                            state_next <= two_st;
                            output_valid_next <= '1';
                            output_data_next <= "10";                 
                        when "01001" => -- 9
                            state_next <= three_st; 
                            output_valid_next <= '1';
                            output_data_next <= "11";                 
                        when "00100" => -- 4
                            state_next <= eof;
                        when "11111" => -- 31 TIMEOUT
                            state_next <= idle;
                            output_err_next <= "01";
                        when others =>
                            state_next <= idle;
                            output_err_next <= "10"; -- "10" UNKNOWN ERROR
                    end case;
                end if;

            when zero_st => -- "00"
                output_valid_next <= '0';
                if input_enable = '1' then
                    case input_value is
                        when "00111" => -- 7
                            output_valid_next <= '1';
                            output_data_next <= "00"; 
                            state_next <= zero_st;               
                        when "01001" => -- 9
                            output_valid_next <= '1';
                            output_data_next <= "01";
                            state_next <= one_st;                 
                        when "01011" => -- 11
                            output_valid_next <= '1';
                            output_data_next <= "10";  
                            state_next <= two_st;               
                        when "01101" => -- 13
                            output_valid_next <= '1';
                            output_data_next <= "11"; 
                            state_next <= three_st;                
                        when "01000" => -- 8
                            state_next <= eof;             
                        when "11111" => -- 31 TIMEOUT
                            output_err_next <= "01";     
                            state_next <= idle;           
                        when others =>
                            state_next <= idle;
                            output_err_next <= "10"; -- "10" UNKNOWN ERROR
                    end case;
                end if;
                      
            when one_st => -- "01"
                output_valid_next <= '0';
                if input_enable = '1' then
                    case input_value is
                        when "00101" => -- 5
                            output_data_next <= "00";
                            output_valid_next <= '1';
                            state_next <= zero_st;                
                        when "00111" => -- 7
                            output_data_next <= "01";
                            output_valid_next <= '1';
                            state_next <= one_st;                 
                        when "01001" => -- 9
                            output_data_next <= "10";
                            output_valid_next <= '1';
                            state_next <= two_st;                
                        when "01011" => -- 11
                            output_data_next <= "11";
                            output_valid_next <= '1';
                            state_next <= three_st;                
                        when "00110" => -- 6
                            state_next <= eof; 
                        when "11111" => -- 31 TIMEOUT
                            state_next <= idle;
                            output_err_next <= "01";              
                        when others =>
                            state_next <= idle;
                            output_err_next <= "10"; -- "10" UNKNOWN ERROR
                    end case;
                end if;

            when two_st => -- "10"
                output_valid_next <= '0';
                if input_enable = '1' then
                    case input_value is
                        when "00011" =>  -- 3
                            output_data_next <= "00";
                            output_valid_next <= '1';
                            state_next <= zero_st;                
                        when "00101" => -- 5
                            output_data_next <= "01";
                            output_valid_next <= '1';
                            state_next <= one_st;
                        when "00111" => -- 7
                            output_data_next <= "10";
                            output_valid_next <= '1';
                            state_next <= two_st;                
                        when "01001" => -- 9
                            output_data_next <= "11";
                            output_valid_next <= '1';
                            state_next <= three_st; 
                        when "00100" => -- 4
                            state_next <= eof;
                        when "11111" =>  -- 31 TIMEOUT
                            state_next <= idle;
                            output_err_next <= "01";
                        when others =>
                            state_next <= idle;
                            output_err_next <= "10"; -- "10" UNKNOWN ERROR
                    end case;
                end if;  
                                                                  
            when three_st => -- "11"
                output_valid_next <= '0';
                if input_enable = '1' then
                    case input_value is
                        when "00001" => -- 1
                            output_valid_next <= '1';
                            output_data_next <= "00";   
                            state_next <= zero_st;              
                        when "00011" => -- 3
                            output_valid_next <= '1';
                            output_data_next <= "01";  
                            state_next <= one_st;              
                        when "00101" => -- 5
                            output_valid_next <= '1';
                            output_data_next <= "10"; 
                            state_next <= two_st;                
                        when "00111" => -- 7
                            output_valid_next <= '1';
                            output_data_next <= "11";   
                            state_next <= three_st;              
                        when "00010" => -- 2
                            state_next <= eof;
                        when "11111" => -- 31 TIMEOUT
                            state_next <= idle;
                            output_err_next <= "01";             
                        when others =>
                            state_next <= idle;
                            output_err_next <= "10"; -- "10" UNKNOWN ERROR
                    end case;
                end if;  

            when eof =>
                state_next <= idle;
                output_end_tx_next <= '1';
                    
            when others =>
                state_next <= idle;
                output_err_next <= "10"; -- "10" UNKNOWN ERROR
                                                                                                    
            end case;
    end process;
    
    -- output logic;
    output_data <= output_data_reg;
    output_valid <= output_valid_reg;
    output_end_tx <= output_end_tx_reg;
    output_err <= output_err_reg;
                           
end fsm_arch;  