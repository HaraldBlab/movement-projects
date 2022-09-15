library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linear_actuator is
    generic (
        wait_count : natural := 2  -- -- wait time for the stepper        
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        btn_start : in std_logic;               -- start button (NO mode)
        limit_closed : in std_logic;            -- limit switch closed (NO mode)
        limit_open : in std_logic;              -- limit switch open (NO mode)
        coils : out std_logic_vector(3 downto 0) -- unipolar stepper 
    );
end linear_actuator;

architecture rtl of linear_actuator is
    -- indicates the motor to stop
    signal stopped : std_logic := '1';
    -- direction of stepper rotation
    signal cw : std_logic := '1';
    -- states used to run the linear actuator
    type operation is ( IDLE, OPERATE, OPERATE_CLOSE, OPERATE_OPEN );
    signal state : operation;
    signal btn_start_p1 : std_logic;
    signal limit_closed_p1 : std_logic;
    signal limit_open_p1 : std_logic;

begin

    STEPPER : entity work.unipolar_stepper(rtl)
    generic map (
        wait_count => wait_count
    )
    port map (
        clk => clk,
        rst => stopped,
        cw => cw,
        coils => coils
    );

    FSM_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                btn_start_p1 <= '0';
                limit_closed_p1 <= '0';
                limit_open_p1 <= '0';
                state <= IDLE;
                stopped <= '1';
    
            else

                btn_start_p1 <= btn_start;
                limit_closed_p1 <= limit_closed;
                limit_open_p1 <= limit_open;
                
                case state is
    
                    when IDLE =>

                        stopped <= '1';

                        if btn_start = '0' and btn_start_p1 = '1' then
                            state <= OPERATE;
                        end if;
                    
                    when OPERATE =>

                        if limit_closed = '0' then -- and limit_closed_p1 = '1' then
                            -- if it is already closed, open it
                            state <= OPERATE_OPEN;
                            cw <= '1';  -- clock wise
                        else
                            -- else close it
                            state <= OPERATE_CLOSE;
                            cw <= '0';  -- counter clock wise
                        end if;
                    
                    when OPERATE_OPEN =>

                        stopped <= '0';
                        if limit_open = '0' and limit_open_p1 = '1' then
                            state <= IDLE;
                        end if;

                    when OPERATE_CLOSE =>

                        stopped <= '0';
                        if limit_closed = '0' and limit_closed_p1 = '1'then
                            state <= IDLE;
                        end if;

                end case;
    
            end if;
        end if;
    end process;

end architecture;
