library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SevSeg_4digit is
    Port ( clk : in STD_LOGIC;
           in0, in1, in2, in3 : in STD_LOGIC_VECTOR(3 downto 0); -- 4 digits input
           a, b, c, d, e, f, g : out STD_LOGIC; -- individual segment outputs
           dp : out STD_LOGIC; -- decimal point output
           an : out STD_LOGIC_VECTOR(3 downto 0) -- anode enable signal
           );
end SevSeg_4digit;

architecture Behavioral of SevSeg_4digit is

    -- Parameters for the counter to generate multiplexing speed
    constant N : integer := 18;
    signal count : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    
    -- Signals for digit value and enable signals
    signal digit_val : STD_LOGIC_VECTOR(3 downto 0);
    signal digit_en : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Signal for 7-segment LED output
    signal sseg_LEDs : STD_LOGIC_VECTOR(6 downto 0);

begin

    -- Process to divide the system clock for multiplexing
    process(clk)
    begin
        if rising_edge(clk) then
            count <= std_logic_vector((count) + 1);
        end if;
    end process;
    
    -- Always block to handle multiplexing logic
    process(count)
    begin
        digit_en <= "1111"; -- default enable value
        digit_val <= in0;  -- default digit value
        
        case count(N-1 downto N-2) is
            when "00" => 
                digit_val <= in0;
                digit_en <= "1110";
            when "01" => 
                digit_val <= in1;
                digit_en <= "1101";
            when "10" => 
                digit_val <= in2;
                digit_en <= "1011";
            when "11" => 
                digit_val <= in3;
                digit_en <= "0111";
            when others =>
                digit_val <= in0;
                digit_en <= "1111"; -- default case
        end case;
    end process;
    
    -- Convert the digit value to corresponding 7-segment LED representation
    process(digit_val)
    begin
        sseg_LEDs <= "1111111"; -- default: all segments off
        case digit_val is
            when "0000" => sseg_LEDs <= "1000000"; -- 0
            when "0001" => sseg_LEDs <= "1111001"; -- 1
            when "0010" => sseg_LEDs <= "0100100"; -- 2
            when "0011" => sseg_LEDs <= "0110000"; -- 3
            when "0100" => sseg_LEDs <= "0011001"; -- 4
            when "0101" => sseg_LEDs <= "0010010"; -- 5
            when "0110" => sseg_LEDs <= "0000010"; -- 6
            when "0111" => sseg_LEDs <= "1111000"; -- 7
            when "1000" => sseg_LEDs <= "0000000"; -- 8
            when "1001" => sseg_LEDs <= "0010000"; -- 9
            when others => sseg_LEDs <= "0111111"; -- Dash
        end case;
    end process;
    
    -- Assign the outputs
    an <= digit_en;
    a <= sseg_LEDs(0);
    b <= sseg_LEDs(1);
    c <= sseg_LEDs(2);
    d <= sseg_LEDs(3);
    e <= sseg_LEDs(4);
    f <= sseg_LEDs(5);
    g <= sseg_LEDs(6);
    dp <= '1'; -- Decimal point is off
    
end Behavioral;
