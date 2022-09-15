library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity linear_actuator_tb is
end linear_actuator_tb;

architecture sim of linear_actuator_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';
    -- start button (NO mode)
    signal btn_start : std_logic := '0';
    -- limit switch closed (NO mode)
    signal limit_closed : std_logic := '0';
    -- limit switch open (NO mode)
    signal limit_open : std_logic := '0';
    -- unipolar stepper 
    signal coils : std_logic_vector(3 downto 0);

    -- wait time for the stepper        
    constant wait_count : natural := 1;  -- 2 ms

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.linear_actuator(rtl)
    generic map (
        wait_count => wait_count 
    )
    port map (
        clk => clk,
        rst => rst,
        btn_start => btn_start,
        limit_closed => limit_closed,
        limit_open => limit_open,
        coils => coils 
    );

    SEQUENCER_PROC : process
        -- time used for a single step (set coils and wait)
        variable step_time : time := (wait_count + 1) * clk_period;
        variable test_time : time := 10 * step_time;

        procedure setup_start(close_switch : in std_logic; open_switch : in std_logic) is
        begin

            rst <= '1';
            btn_start <= '0';
            wait for 2*clk_period;
            rst <= '0';
            wait for 2*clk_period;    

            limit_closed <= close_switch;
            limit_open <= open_switch;
            wait for clk_period;

            btn_start <= '1';
            wait for clk_period;
            btn_start <= '0';
        
        end procedure;
    begin
        wait for clk_period * 2;

        report "Verifing reset rst <= '1'";

        rst <= '1';

        wait for clk_period;
        assert coils = "0000"
            report "Expected coils to be '0000'"
            severity failure;

        report "Verifing reset rst <= '0'";
            
        rst <= '0';

        wait for clk_period;
        assert coils = "0000"
            report "Expected coils to be '0000'"  
            severity failure;

        report "Verifing start mechanism in closed state";

        setup_start('1', '0');

        wait for test_time;
        assert coils = "0001"
            report "Expected coils to be '0001'"  
            severity failure;

        report "Verifing start mechanism in opened state";

        setup_start('0', '1');

        wait for test_time;
        assert coils = "0001"
            report "Expected coils to be '0001'"  
            severity failure;

        report "Verifing state mechanism in unknown state";
        
        setup_start('0', '0');

        wait for test_time;
        assert coils = "1000"
            report "Expected coils to be '1000'"  
            severity failure;
        report "** Verify this ***";
    
        report "Verifing stop mechanism in opened state";

        setup_start('0', '1');

        wait for test_time;
        limit_closed <= '1';
        wait for 3*clk_period;

        assert coils = "0000"
            report "Expected coils to be '0000'"  
            severity failure;

        report "Verifing stop mechanism in closed state";

        setup_start('1', '0');

        wait for test_time;
        limit_open <= '1';
        wait for 3*clk_period;

        assert coils = "0000"
            report "Expected coils to be '0000'"  
            severity failure;

        report "Test successful";


        finish;
    end process;

end architecture;