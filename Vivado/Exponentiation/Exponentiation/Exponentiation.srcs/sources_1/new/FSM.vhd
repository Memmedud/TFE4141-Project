library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FSM is
    generic(
        C_block_size    : integer := 256
    );
    Port(
        valid_in        : STD_LOGIC;
        valid_out       : STD_LOGIC;
        ready_in        : STD_LOGIC;
        ready_out       : STD_LOGIC;
        
        clk             : STD_LOGIC;
        rst_n           : STD_LOGIC
    );
end FSM;

architecture Behavioral of FSM is

type state_type is (IDLE, CALCULATING, MODMUL, PRINT);

signal state        : state_type := IDLE;
signal state_nxt    : state_type := IDLE;

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

    process()
    begin
        
    end process;


end Behavioral;
