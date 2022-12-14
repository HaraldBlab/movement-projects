library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

entity servo_tb is
end servo_tb; 

architecture sim of servo_tb is

  constant clk_hz : real := 1.0e6;
  constant clk_period : time := 1 sec / clk_hz;

  constant pulse_hz : real := 50.0;
  constant pulse_period : time := 1 sec / pulse_hz;
  constant min_pulse_us : real := 1800.0;
  constant max_pulse_us : real := 2400.0;
  constant step_count : positive := 18;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal position : integer range 0 to step_count - 1;
  signal pwm : std_logic;

begin

  clk <= not clk after clk_period / 2;

  DUT : entity work.servo(rtl)
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

  SEQUENCER : process
  begin
    wait for 10 * clk_period;
    rst <= '0';

    wait for pulse_period;

    report "Simulation 90 to 160";
    for i in 9 to 16 loop
      position <= i;
      wait for pulse_period;
    end loop;

    report "Simulation 160 downto 20";
    for i in 16 downto 2 loop
      position <= i;
      wait for pulse_period;
    end loop;

    report "Simulation 20 to 90";
    for i in 2 to 9 loop
      position <= i;
      wait for pulse_period;
    end loop;


    report "Simulation done. Check waveform.";
    finish;
  end process;

end architecture;