library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity position is
    generic (
        step_count : positive := 256;
        step_bits : positive := 8; 
        pos_min : integer := 0;
        pos_max : integer := 255
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        data : in unsigned(step_bits - 1 downto 0);
        pos : out integer range 0 to step_count - 1
        );
end position;

architecture rtl of position is

    constant pos_start : integer := step_count / 2;
    constant data_0 : unsigned(step_bits - 1 downto 0) := (others => '0');

    type direction_type is (INCR1, DECR, INCR2, SKIP);
    signal direction : direction_type;
    signal last_value : unsigned(step_bits - 1 downto 0);
    signal last_pos : integer;

    begin

    -- procdeure to calculate position based on signal
    -- on a change of addr the value is mapped to pos_min .. pos_max
    POSITION_PROC : process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                
                pos <= pos_start;  -- 90 deg
                direction <= INCR1;
                last_pos <= pos_start;
    
            else

                last_value <= data;

                if (not (data = last_value)) then

                    case direction is

                        when INCR1 =>
                            if (last_pos < pos_max) then
                                last_pos <= last_pos + 1;
                                pos <= last_pos;
                            elsif (last_pos = pos_max) then
                                last_pos <= pos_max - 1;
                                pos <= last_pos;
                                direction <= DECR;
                            end if;

                        when DECR =>
                            if (last_pos > pos_min) then
                                last_pos <= last_pos - 1;
                                pos <= last_pos;
                            elsif (last_pos = pos_min) then
                                last_pos <= pos_min - 1; 
                                pos <= last_pos;
                                direction <= INCR2;
                            end if;

                        when INCR2 =>
                            if (last_pos < pos_start) then
                                last_pos <= last_pos + 1;
                                pos <= last_pos;
                            elsif (last_pos = pos_start) then
                                last_pos <= pos_start;
                                pos <= last_pos;
                                direction <= SKIP;
                            end if;

                        when SKIP =>
                            pos <= pos_start;
                            if (data = data_0) then
                                direction <= INCR1;
                            end if;
                    end case;
                end if;
            end if;
        end if;
    end process;
end architecture;
