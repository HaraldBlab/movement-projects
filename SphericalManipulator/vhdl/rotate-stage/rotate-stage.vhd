library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rotate_stage is
    generic (
        step_bits : positive := 8;
        cnt_bits : integer := 25
    );
    port (
        clk : in std_logic;
        rst_n : in std_logic;
        pwm : out std_logic_vector(2 downto 0)
    );
end rotate_stage;

architecture rtl of rotate_stage is

    constant clk_hz : real := 12.0e6; -- Lattice iCEstick clock
    constant pulse_hz : real := 50.0;
    -- TowerPro SG90 values
    constant min_pulse_us : real := 500.0; 
    constant max_pulse_us : real := 2500.0;
    -- we use step_count steps to move from min to max
    constant step_count : positive := 2**step_bits;
    constant pos_min : positive := (integer(real(step_count) / 180.0 * 20.0));
    constant pos_max : positive := step_count - pos_min;
  
    -- Wraps in 2.8 seconds at 12 MHz
    signal cnt : unsigned(cnt_bits - 1 downto 0);
  
    signal rst : std_logic;
    signal pwm_single : std_logic;
    signal position : integer range 0 to step_count - 1;

begin

    --- 3 servos that perfom the identical operation
    pwm <= pwm_single & pwm_single & pwm_single;

    RESET : entity work.reset(rtl)
    port map (
      clk => clk,
      rst_n => rst_n,
      rst => rst
    );
    
    POSITIONER: entity work.position(rtl)
    generic map(
      step_count => step_count,
      step_bits => step_bits,
      pos_min => pos_min,
      pos_max => pos_max
    )
    port map (
      clk => clk,
      rst => rst,
      data => cnt(cnt'left downto cnt'left - step_bits + 1),
      pos => position
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
      pwm => pwm_single
    );

    end architecture;