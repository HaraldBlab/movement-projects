library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity rotate_stage_tb is
end rotate_stage_tb;

architecture sim of rotate_stage_tb is

    constant clk_hz : integer := 12e6;
    constant clk_period : time := 1 sec / clk_hz;
    constant cnt_bits : integer := 25;
    constant step_bits : positive := 8;

    signal clk : std_logic := '1';
    signal rst_n : std_logic := '0';
    signal pwm : std_logic_vector(2 downto 0);

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.rotate_stage(rtl)
    generic map (
        step_bits => step_bits,
        cnt_bits => cnt_bits
    )
    port map (
        clk => clk,
        rst_n => rst_n,
        pwm => pwm
    );

    SEQUENCER_PROC : process
        variable step_time : time := 2*128*128*256 * clk_period;
    begin
        wait for clk_period * 2;

        report "Verifying rst_n = '1'";
        rst_n <= '0';
        wait for clk_period * 10;

        report "Verifying rst_n = '0'";
        rst_n <= '1';
        wait for clk_period * 10;

        report "Verifying pwm position at (1/8)";
        wait for step_time;

        report "Verifying pwm position at (2/8)";
        wait for step_time;

        report "Verifying pwm position at (3/8)";
        wait for step_time;

        report "Verifying pwm position at (4/8)";
        wait for step_time;

        report "Verifying pwm position at (5/8)";
        wait for step_time;

        report "Verifying pwm position at (6/8)";
        wait for step_time;

        report "Verifying pwm position at (7/8)";
        wait for step_time;

        report "Verifying pwm position at (8/8)";
        wait for step_time;

        wait for clk_period * 4;

        report "Test successful.";

        finish;
    end process;

end architecture;