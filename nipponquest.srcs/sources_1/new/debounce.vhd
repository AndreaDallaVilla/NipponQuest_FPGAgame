library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
generic( counter_size: integer:=20);

 Port ( 
        clk: in std_logic;
        button: in std_logic;
        result: out std_logic
 
 );
end debounce;

architecture Behavioral of debounce is
signal flipflops: std_logic_vector(1 downto 0);
signal counter_set: std_logic;
signal counter_out: std_logic_vector(counter_size downto 0):=(others=>'0');
begin
    
    counter_set<=flipflops(0) xor flipflops(1); --determine when to start/reset counter

process(clk) begin
if (rising_edge(clk)) then
flipflops(0)<=button;
flipflops(1)<=flipflops(0);
if(counter_set='1') then  --reset counter because input is changing
counter_out<=(others=>'0');
elsif(counter_out(counter_size)='0') then   --stable input time is not yet met
counter_out<=counter_out + 1;
else    --stable input time is met
result<=flipflops(1);
end if;
end if;
end process;


end Behavioral;
