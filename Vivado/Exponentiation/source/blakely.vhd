library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blakely is
    generic (
        C_block_size : integer := 256
    );
    port (
        -- Clock and reset
        clk             :  in STD_LOGIC;
        rst_n           :  in STD_LOGIC;

        -- Inputs
        a               :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        b               :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        nega_n          :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        nega_2n         :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        blakely_enable  :  in STD_LOGIC;

        -- Outputs
        result          : out STD_LOGIC_VECTOR(C_block_size - 1 downto 0)
        blakely_done    : out STD_LOGIC;
    );
end blakely;

architecture rtl of blakely is

signal bi               : STD_LOGIC;

signal result_nxt       : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal result_bitshift  : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal result_r         : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);

signal sum_a            : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal mux_bi           : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal sum_n            : STD_LOGIC_VECTOR(C_block_size downto 0);
signal sum_2n           : STD_LOGIC_VECTOR(C_block_size downto 0);

signal overflow1        : STD_LOGIC;
signal overflow2        : STD_LOGIC;

signal counter          : STD_LOGIC_VECTOR(integer(ceil(log2(real(C_block_size))))-1 downto 0);

begin
    -- Sequential datapath
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            result_r <= (others => '0');
        elsif (rising_edge(clk)) then
            if (blakely_enable = '1') then
                result_r <= result_nxt;
                counter <= counter + 1;
            else
                result_r <= result_r;
                counter <= (others => 0);
        end if;
    end process;

    -- Combinatorial Blakely algorithm
    process(a, bi, nega_n, nega_2n, result_r, result_nxt, result_bitshift, sum_a, mux_bi, sum_n, sum_2n, overflow1, overflow2)
    begin
        result_bitshift <= STD_LOGIC_VECTOR(shift_left(unsigned(result_r), 1));
        sum_a <= STD_LOGIC_VECTOR(signed(result_bitshift) + signed(a));
        
        if(bi = '1') then
            mux_bi <= sum_a;
        else
            mux_bi <= result_bitshift;
        end if;

        sum_n   <= STD_LOGIC_VECTOR(resize(signed(nega_n), C_block_size+1) + resize(signed(mux_bi), C_block_size+1));
        sum_2n  <= STD_LOGIC_VECTOR(resize(signed(nega_2n), C_block_size+1) + resize(signed(mux_bi), C_block_size+1));
        overflow1 <= sum_n(C_block_size);
        overflow2 <= sum_2n(C_block_size);

        if(overflow1 = '1' AND overflow2 = '1') then
            result_nxt <= mux_bi;
        elsif(overflow1 = '0' AND overflow2 = '1') then
            result_nxt <= sum_n(C_block_size - 1 downto 0);
        elsif(overflow1 = '0' AND overflow2 = '0') then
            result_nxt <= sum_2n(C_block_size - 1 downto 0);
        else
            result_nxt <= (others => '0');
        end if;
    end process;

    -- Output control signal
    process(counter)
    begin
        if (counter = C_block_size-1) then
            blakely_done <= '1';
        else
            blakely_done <= '0';
        end if;
    end process
    
    result <= result_r;
    bi <= b(to_integer(unsigned(index)));
    
end rtl;