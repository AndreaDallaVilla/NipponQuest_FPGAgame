library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
entity pdm_inputs is
  generic (
    CLK_FREQ    : integer := 100;      -- MHz
    SAMPLE_RATE : integer := 2400000   -- Hz
  );
  port (
    clk: in  std_logic;                             
    -- Microphone interface
    m_clk: out std_logic;                           -- Clock for the microphone
    m_clk_en: inout std_logic;                      -- Clock enable for the microphone
    m_data : in  std_logic;                         -- PDM data input from the microphone
    -- Amplitude outputs
    amplitude: out std_logic_vector(6 downto 0);    
    amplitude_valid : out std_logic                
  );
end entity pdm_inputs;

architecture rtl of pdm_inputs is
  
  constant CLK_COUNT : integer := (CLK_FREQ*1000000)/(SAMPLE_RATE*2);   
  function clog2(x : positive) return natural is
  begin
    return natural(ceil(log2(real(x))));
  end function;
  
  type counter_array is array (0 to 1) of unsigned(7 downto 0);
  signal counter        : counter_array := (others => (others => '0')); 
  signal sample_counter : counter_array := (others => (others => '0')); 
  signal clk_counter    : unsigned(clog2(CLK_COUNT)-1 downto 0) := (others => '0'); 
  signal m_clk_internal : std_logic := '0'; 

  
begin
  m_clk <= m_clk_internal;
  
  main_process: process(clk)
  begin
    if rising_edge(clk) then
      amplitude_valid <= '0';
      m_clk_en <= '0';
      
      if clk_counter = to_unsigned(CLK_COUNT - 1, clk_counter'length) then 
        clk_counter <= (others => '0'); 
        m_clk_internal <= not m_clk_internal; 
        m_clk_en <= not m_clk_internal; 
      else
        clk_counter <= clk_counter + 1;
        if clk_counter = to_unsigned(CLK_COUNT - 2, clk_counter'length) then
          m_clk_en <= not m_clk_internal; 
        end if;
      end if;
      
    
      if m_clk_en = '1' then
        counter(0) <= counter(0) + 1;
        counter(1) <= counter(1) + 1;
        
        if counter(0) = to_unsigned(199, 8) then 
          counter(0) <= (others => '0');
          amplitude <= std_logic_vector(sample_counter(0)(6 downto 0));
          amplitude_valid <= '1'; 
          sample_counter(0) <= (others => '0');
        elsif counter(0) < to_unsigned(128, 8) then 
          if m_data = '1' then
            sample_counter(0) <= sample_counter(0) + 1;
          end if;
        end if;
        
        if counter(1) = to_unsigned(227, 8) then 
          counter(1) <= (others => '0');
          
          if m_data = '1' then  
            amplitude <= std_logic_vector(sample_counter(1)(6 downto 0) + "0000001"); 
          else
            amplitude <= std_logic_vector(sample_counter(1)(6 downto 0));
          end if;
          amplitude_valid <= '1';
          sample_counter(1) <= (others => '0');
        elsif counter(1) > to_unsigned(100, 8) then 
          if m_data = '1' then
            sample_counter(1) <= sample_counter(1) + 1;
          end if;
        end if;
      end if;
    end if;
  end process main_process;
  
end architecture rtl;