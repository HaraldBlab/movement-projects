library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    clk : in std_logic;
    rst_n : in std_logic; -- Pullup
    pwm : out std_logic
  );
end top;

architecture str of top is

  constant clk_hz : real := 12.0e6; -- Lattice iCEstick clock
  constant pulse_hz : real := 50.0;
  constant min_pulse_us : real := 500.0; -- TowerPro SG90 values
  constant max_pulse_us : real := 2500.0; -- TowerPro SG90 values
  constant step_bits : positive := 8; -- 0 to 255
  constant step_count : positive := 2**step_bits;

  -- Wraps in 2.8 seconds at 12 MHz
  constant cnt_bits : integer := 25;
  signal cnt : unsigned(cnt_bits - 1 downto 0);

  signal rst : std_logic;
  signal position : integer range 0 to step_count - 1;
  signal rom_addr : unsigned(step_bits - 1 downto 0);
  signal rom_data : unsigned(step_bits - 1 downto 0);

begin

  position <= to_integer(rom_data);
  rom_addr <= cnt(cnt'left downto cnt'left - step_bits + 1);

  RESET : entity work.reset(rtl)
  port map (
    clk => clk,
    rst_n => rst_n,
    rst => rst
  );

  SERVO : entity work.servo(rtl)
  generic map (
    clk_hz => clk_hz,
    pulse_hz => pulse_hz,
    min_pulse_us => min_pulse_us,
    max_pulse_us => max_pulse_us,
    step_count => step_count
  )
  port map (
    clk => clk,
    rst => rst,
    position => position,
    pwm => pwm
  );

  COUNTER : entity work.counter(rtl)
  generic map (
    counter_bits => cnt_bits
  )
  port map (
    clk => clk,
    rst => rst,
    count_enable => '1',
    counter => cnt
  );

  SINE_ROM : entity work.sine_rom(rtl)
  generic map (
    data_bits => step_bits,
    addr_bits => step_bits
  )
  port map (
    clk => clk,
    addr => rom_addr,
    data => rom_data
  );

end architecture;