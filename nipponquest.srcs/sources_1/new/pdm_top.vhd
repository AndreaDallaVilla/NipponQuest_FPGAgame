library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity pdm_top is
  generic (
    RAM_SIZE : integer := 16384;
    CLK_FREQ : integer := 100
  );
  port (
    clk      : in  std_logic;                     -- 100Mhz clock
    -- Microphone interface
    m_clk    : out std_logic;
    m_lr_sel : out std_logic; 
    m_data   : in  std_logic;
    -- Tricolor LED
    R        : out std_logic;
    G        : out std_logic;
    B        : out std_logic
  );
end entity pdm_top;

architecture rtl of pdm_top is
 
  signal amplitude       : std_logic_vector(6 downto 0);
  
  
  signal amplitude_valid : std_logic;
 
  
  
  signal m_clk_en        : std_logic;
  signal light_count     : unsigned(6 downto 0) := (others => '0');
  
  signal AUD_SD : std_logic := '1';
  constant NOISE_THRESHOLD : integer := 65;
begin
  m_lr_sel <= '0';
  
  u_pdm_inputs: entity work.pdm_inputs
    port map (
      clk             => clk,
      m_clk           => m_clk,
      m_clk_en        => m_clk_en,
      m_data          => m_data,
      amplitude       => amplitude,
      amplitude_valid => amplitude_valid
    );
    

  led_process: process(clk)
  begin
    if rising_edge(clk) then
      if m_clk_en = '1' then
        light_count <= light_count + 1;
      end if;
      
      if unsigned(amplitude) > NOISE_THRESHOLD then
        B <= '1';  
      else
        B <= '0';
      end if;
      R <= '0';
      G <= '0';
    end if;
  end process led_process;

end architecture rtl;