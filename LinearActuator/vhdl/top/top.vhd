library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk : in std_logic;
        rst_n : in std_logic;           -- Pullup
        btn_start : in std_logic;       -- Pullup
        limit_closed : in std_logic;    -- Pullup
        limit_open : in std_logic;      -- Pullup
        coils : out std_logic_vector(3 downto 0)
    );
end top;

architecture rtl of top is
    -- TODO: Lattice ICE40 specific (constant_pck)
    constant clk_hz : integer := 12e6;

    -- debounced buttons and switches
    signal btn_start_debounced : std_logic;
    signal limit_closed_debounced : std_logic;
    signal limit_open_debounced : std_logic;
    
    -- current direction
    constant cw: std_logic := '1';
    -- current speed (slowlyness)
    -- 2 ms  wait time for the stepper
    constant wait_count : natural := 24000;    
    -- 10 ms  wait time for button debouncer 
    constant debounce_count : natural := 120000;        

    -- Internal reset
    signal rst : std_logic;

begin

    RESET : entity work.reset(rtl)
    port map (
      clk => clk,
      rst_n => rst_n,
      rst => rst
    );

    BUTTON_START : entity work.debouncer(rtl)
    generic map (
        timeout_cycles => debounce_count
    )
    port map (
      clk => clk,
      rst => rst,
      switch => btn_start,
      switch_debounced => btn_start_debounced
    ); 

    LIMITSWITCH_OPEN : entity work.debouncer(rtl)
    generic map (
        timeout_cycles => debounce_count
    )
    port map (
      clk => clk,
      rst => rst,
      switch => limit_open,
      switch_debounced => limit_open_debounced
    ); 

    LIMITSWITCH_CLOSE : entity work.debouncer(rtl)
    generic map (
        timeout_cycles => debounce_count
    )
    port map (
      clk => clk,
      rst => rst,
      switch => limit_closed,
      switch_debounced => limit_closed_debounced
    ); 


    LINEAR_ACTUATOR : entity work.linear_actuator(rtl)
    generic map (
        wait_count => wait_count 
    )
    port map (
        clk => clk,
        rst => rst,
        btn_start => btn_start_debounced,
        limit_closed => limit_closed_debounced,
        limit_open => limit_open_debounced,
        coils => coils 
    );

end architecture;