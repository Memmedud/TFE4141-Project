library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity FSM is
    generic(
        C_block_size    : integer := 256
    );
    Port(
        valid_in        : in STD_LOGIC;
        valid_out       : out STD_LOGIC;
        ready_in        : out STD_LOGIC;
        ready_out       : in STD_LOGIC;

        index           : out std_logic_vector(integer(ceil(log2(real(C_block_size))))-1 downto 0);
        write_mes       : out std_logic;
        blakely_enable  : out std_logic;
        blakely_done    : in  std_logic;

        -- Clock and reset
        clk             : in STD_LOGIC;
        rst_n           : in STD_LOGIC
    );
end FSM;

architecture Behavioral of FSM is

-- FSM states
type state_type is (IDLE, CALCULATING, MODMUL, PRINT);
signal state        : state_type := IDLE;
signal state_nxt    : state_type := IDLE;

-- Counters
signal counterModMul    : unsigned(integer(ceil(log2(real(C_block_size))))-1 downto 0);
signal counterRSA       : unsigned(integer(ceil(log2(real(C_block_size))))-1 downto 0);

begin
    -- Sequential datapath
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            state <= IDLE;
        elsif (rising_edge(clk)) then
            state <= state_nxt;
        end if;
    end process;

    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            counterModMul   <= (others => '0');
            counterRSA      <= (others => '0');
        elsif (rising_edge(clk)) then
            if (state = MODMUL) then
                counterModMul <= counterModMul + 1;
            end if;
            if (state = CALCULATING) then
                counterRSA <= counterRSA + 1;
            end if;
        end if;
    end process;

    -- Combinatorial datapath
    process(valid_in, ready_out, counterRSA, counterModMul, state, clk)
    begin
        case (state) is
        when IDLE =>
            if (valid_in = '1') then
                state_nxt <= CALCULATING;
            else 
                state_nxt <= IDLE;
            end if;
            
        when CALCULATING =>
            if (counterRSA = 255) then
                state_nxt <= PRINT;
            else
                state_nxt <= MODMUL;
            end if;

        when MODMUL =>       
            if (counterModMul = 255) then
                state_nxt <= CALCULATING;
            else 
                state_nxt <= MODMUL;
            end if;

        when PRINT =>
            if (ready_out = '1') then
                state_nxt <= IDLE;
            else
                state_nxt <= PRINT;
            end if;
        end case;
    end process;

    process(state)
    begin
        case (state) is
        when IDLE =>
            ready_in <= '0';
            valid_out <= '0';
            write_mes <= '1';

        when CALCULATING =>
            valid_out <= '0';
            ready_in <= '0';
            write_mes <= '0';

        when PRINT =>
            valid_out <= '1';
            ready_in <= '0';
            write_mes <= '0';
    end process;
    
    index <= std_logic_vector(counterRSA);

end Behavioral;
