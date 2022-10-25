library ieee;
use ieee.std_logic_1164.all;

entity blakely is
    generic (
        C_block_size : integer := 256
    );
    port (
        clk         :  in STD_LOGIC;
        rst_n       :  in STD_LOGIC;

        a           :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        bi          :  in STD_LOGIC;                                         -- From PISO register
        nega_n      :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        nega_2n     :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);

        result      : out STD_LOGIC_VECTOR(C_block_size - 1 downto 0)
    );
end blakely;

architecture rtl of blakely is

signal result_nxt       : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal result_bitshift  : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);

signal sum_a            : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal mux_bi           : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal sum_n            : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal sum_2n           : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);

signal overflow1        : STD_LOGIC;
signal overflow2        : STD_LOGIC;

begin
    -- Sequential datapath
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            result <= (others => '0');
        elsif (rising_edge(clk)) then
            result <= result_next;
        end if;
    end process;

    -- Combinatorial datapath
    process(a, bi, nega_n, nega_2n, result, result_nxt, result_bitshift, sum_a, mux_bi, sum_n, sum_2n, overflow1, overflow2)
    begin
        

    end process;
end rtl;