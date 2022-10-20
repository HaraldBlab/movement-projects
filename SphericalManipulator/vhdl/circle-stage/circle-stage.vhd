library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circle_stage is
    generic (
        step_bits : positive := 8;
        cnt_bits : integer := 25
    );
    port (
        clk : in std_logic;
        rst_n : in std_logic;
        pwm : out std_logic_vector(2 downto 0)
    );
end circle_stage;

architecture rtl of circle_stage is

    constant clk_hz : real := 12.0e6; -- Lattice iCEstick clock
    constant pulse_hz : real := 50.0;
    -- TowerPro SG90 values
    constant min_pulse_us : real := 500.0; 
    constant max_pulse_us : real := 2500.0;
    -- we use step_count steps to move from min to max
    constant step_count : positive := 2**step_bits;
    constant pos_90 : positive := step_count/2;
    constant pos_120 : integer := 2*step_count/2/3;
    constant pos_240 : integer := 4*step_count/2/3;

    type pos_offset_type is array (0 to 2) of integer; 
    constant pos_offset : pos_offset_type := ( 0, pos_120, pos_240 );

    -- Wraps in 2.8 seconds at 12 MHz
    signal cnt : unsigned(cnt_bits - 1 downto 0);
  
    signal rst : std_logic;

    type position_array is array (0 to 2) of integer range 0 to step_count - 1; 
    signal position : position_array;

    -- used with sine in ROM
    type rom_array  is array (0 to 2) of unsigned(step_bits - 1 downto 0);
    -- scaled angle maps  0..360 deg map to 0..255
    signal angle : rom_array;
    -- 1 + sin(angle) mapped to 0..255 
    signal sin : rom_array;
  
    -- maps a (scaled) angle to 0.255
    function map_angle(angle_in :  unsigned(step_bits - 1 downto 0); angle_off : integer) 
      return unsigned is
        variable angle : integer;
      begin
        angle := to_integer(angle_in + angle_off);
        if (angle > step_count) then
          angle := angle - step_count;
        end if;
        return to_unsigned(angle, step_bits);
      end function;

    -- maps a sin(angle) to a servo position
    function map_position(sin_in : unsigned(step_bits - 1 downto 0))
      return integer is
        variable sin : integer;
      begin
        -- servoAngle = 90+ 30*sin(angle);
        sin := to_integer(sin_in);
        return (256 + sin) / 3;
        -- if (sin < step_count/2) then
        --   return pos_90 - (step_count - sin) / 12;
        -- else
        --   return pos_90 + sin / 12;
        -- end if;
      end function;

    -- angle = ((double)i)/24;
    -- servoAngle1 = 90+ 30*sin(angle);
    -- servoAngle2 = 90+ 30*sin(angle + 2* PI/3);
    -- servoAngle3 = 90+ 30*sin(angle + 4*PI/3);
    -- servo1.write(servoAngle1);
    -- servo2.write(servoAngle2);
    -- servo3.write(servoAngle3);


  begin

    POSITIONS : for i in 0 to 2 generate

      position(i) <= map_position(sin(i));
  
    end generate;

    ANGLES : for i in 0 to 2 generate

      angle(i) <= map_angle(cnt(cnt'left downto cnt'left - step_bits + 1),  pos_offset(i) );

    end generate;

    RESET : entity work.reset(rtl)
    port map (
      clk => clk,
      rst_n => rst_n,
      rst => rst
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

    SERVOS : for i in 0 to 2 generate

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
        position => position(i),
        pwm => pwm(i)
      );

    end generate;

    SINES : for i in 0 to 2 generate

      SINE_ROM : entity work.sine_rom(rtl)
      generic map (
        data_bits => step_bits,
        addr_bits => step_bits
      )
      port map (
        clk => clk,
        addr => angle(i),
        data => sin(i)
      );

    end generate;

    end architecture;