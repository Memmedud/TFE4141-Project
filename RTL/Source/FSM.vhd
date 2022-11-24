library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity FSM is
    generic(
        C_block_size    : integer := 256
    );
    Port(
        clk             : in STD_LOGIC;
        rst_n           : in STD_LOGIC;

        valid_in        : in STD_LOGIC;
        valid_out       : out STD_LOGIC;
        ready_in        : out STD_LOGIC;
        ready_out       : in STD_LOGIC;

        blakely_done    : in  std_logic;
        blakely_enable  : out std_logic; 

        e_index         : out std_logic_vector(integer(ceil(log2(real(C_block_size))))-1 downto 0)
    );
end FSM;

architecture Behavioral of FSM is

type state_type is (WAITING, CALCULATING, BLAKELY, OUTPUTTING);
signal state        : state_type;
signal state_nxt    : state_type;

-- Counters
signal counter      : unsigned(integer(ceil(log2(real(C_block_size))))-1 downto 0);

begin
    -- Sequential datapath
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            state   <= WAITING;
        elsif (rising_edge(clk)) then
            state   <= state_nxt;
        end if;
    end process;

    -- Counters
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            counter <= (others => '0');
        elsif (rising_edge(clk)) then
            if (state = CALCULATING) then
                counter <= counter + 1;
            else
                counter <= counter;
            end if;
        end if;
    end process;

    -- FSM state control
    process(valid_in, ready_out, state, blakely_done, counter)
    begin
        case (state) is
        when WAITING =>
            if (valid_in = '1') then
                state_nxt <= BLAKELY;
            else 
                state_nxt <= WAITING;
            end if;
            
        when CALCULATING =>
            if (and counter = '1') then
                state_nxt <= OUTPUTTING;
            else
                state_nxt <= BLAKELY;
            end if;

        when BLAKELY =>
            if (blakely_done = '1') then
                state_nxt <= CALCULATING;
            else 
                state_nxt <= BLAKELY;
            end if;

        when OUTPUTTING =>
            if (ready_out = '1') then
                state_nxt <= WAITING;
            else
                state_nxt <= OUTPUTTING;
            end if;
        end case;
    end process;

    -- FSM output control
    process(state)
    begin
        case (state) is
        when WAITING => 
            ready_in        <= '1';
            valid_out       <= '0';
            blakely_enable  <= '0';

        when CALCULATING =>
            ready_in        <= '0';
            valid_out       <= '0';
            blakely_enable  <= '0';

        when BLAKELY =>
            ready_in        <= '0';
            valid_out       <= '0';
            blakely_enable  <= '1'; 

        when OUTPUTTING =>
            ready_in        <= '0';
            valid_out       <= '1';
            blakely_enable  <= '0';

        end case;
    end process;
    
    e_index <= std_logic_vector(counter);
  
end Behavioral;
