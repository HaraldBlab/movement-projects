library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity top_tb is
end top_tb;

architecture sim of top_tb is

    constant clk_hz : integer := 12e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst_n : std_logic := '1';
    -- start button (NO mode)
    signal btn_start : std_logic := '1';
    -- limit switch closed (NO mode)
    signal limit_closed : std_logic := '1';
    -- limit switch open (NO mode)
    signal limit_open : std_logic := '1';
    -- unipolar stepper 
    signal coils : std_logic_vector(3 downto 0);

    -- current direction
    signal cw: std_logic := '1';
    -- current speed (slowlyness)
    constant wait_count : natural := 24000;  -- 2 ms  wait time for the stepper        
    -- time used debouncing key presses
    constant debounce_count : natural := 12000;  -- 1 ms  wait time for button debouncer        

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.top(rtl)
    port map (
        clk => clk,
        rst_n => rst_n,
        btn_start => btn_start,
        limit_closed => limit_closed,
        limit_open => limit_open,
        coils => coils
    );

    SEQUENCER_PROC : process
        variable step_time : time := (wait_count + 1) * clk_period;
        variable reset_time : time := 4 * clk_period;
        variable test_time : time := 10 * step_time;
        variable debounce_time : time := (debounce_count + 1) * clk_period;

        procedure setup_start(close_switch : in std_logic; open_switch : in std_logic) is
            begin
    
                btn_start <= '1';
                limit_closed <= '1';
                limit_open <= '1';
                wait for debounce_time;
                rst_n <= '0';
                wait for reset_time;
                rst_n <= '1';
                wait for reset_time;
    
                limit_closed <= close_switch;
                limit_open <= open_switch;
                wait for debounce_time;
    
                btn_start <= '0';
                wait for debounce_time;
            
            end procedure;
    
    begin
        wait for clk_period * 2;

        report "Verifing reset rst_n <= '0'";

        rst_n <= '0';
        wait for reset_time;

        wait for clk_period;
        assert coils = "0000"
            report "Expected coils to be '0000'"
            severity failure;

        report "Verifing reset rst_n <= '1'";
        
        rst_n <= '1';
        wait for reset_time;

        assert coils = "0000"
            report "Expected coils to be '0000'" & 
            "actual '0x" & to_hstring(coils) & "'"
            severity failure;
    
        report "Verifing start mechanism in closed state";

        setup_start('0', '1');

        wait for test_time;

        limit_open <= '0';
        wait for debounce_time;

        assert coils = "0000"
            report "Expected coils to be '0000'"  
            severity failure;

        report "Verifing start mechanism in open state";

        setup_start('1', '0');

        wait for test_time;

        limit_closed <= '0';
        wait for debounce_time;

        assert coils = "0000"
            report "Expected coils to be '0000'"  
            severity failure;
    
        report "Verifing start mechanism in unknown state";

        setup_start('1', '1');

        wait for test_time;

        limit_closed <= '0';
        wait for debounce_time;
        wait for 3*clk_period;

        assert coils = "0000"
            report "Expected coils to be '0000'"  
            severity failure;
        
        report "Test successful.";

            finish;
    end process;

end architecture;