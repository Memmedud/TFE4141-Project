library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

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
        n               :  in STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        blakely_enable  :  in STD_LOGIC;

        -- Outputs
        result          : out STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
        blakely_done    : out STD_LOGIC
    );
end blakely;

architecture rtl of blakely is

signal bi               : STD_LOGIC;
signal n_shifted        : STD_LOGIC_VECTOR(C_block_size downto 0);

signal result_nxt       : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);
signal result_bitshift  : STD_LOGIC_VECTOR(C_block_size downto 0);
signal result_r         : STD_LOGIC_VECTOR(C_block_size - 1 downto 0);

signal sum_a            : STD_LOGIC_VECTOR(C_block_size downto 0);
signal mux_bi           : STD_LOGIC_VECTOR(C_block_size downto 0);
signal sum_n            : STD_LOGIC_VECTOR(C_block_size downto 0);
signal sum_2n           : STD_LOGIC_VECTOR(C_block_size downto 0);

signal underflow1       : STD_LOGIC;
signal underflow2       : STD_LOGIC;
signal mux_bi_underflow : STD_LOGIC;  

signal counter          : STD_LOGIC_VECTOR(integer(ceil(log2(real(C_block_size))))-1 downto 0);
signal blakely_done_nxt : STD_LOGIC;

begin
    -- Sequential datapath
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            result_r <= (others => '0');
            counter <= (others => '1');
            blakely_done <= '0';
        elsif (rising_edge(clk)) then
            if (blakely_enable = '1') then
                result_r <= result_nxt;
                counter <= std_logic_vector(unsigned(counter) - 1);
                blakely_done <= blakely_done_nxt;
            else
                result_r <= (others => '0');
                counter <= (others => '1');
                blakely_done <= '0';
            end if;
        end if;
    end process;

    -- Combinatorial Blakely algorithm
    process(a, bi, n, n_shifted, result_r, result_nxt, result_bitshift, sum_a, mux_bi, sum_n, sum_2n, underflow1, underflow2, mux_bi_underflow)
    begin
        -- Calculate some intermediate values
        result_bitshift <= STD_LOGIC_VECTOR(shift_left(resize(signed(result_r), C_block_size+1), 1));
        sum_a <= STD_LOGIC_VECTOR(unsigned(result_bitshift) + resize(unsigned(a), C_block_size+1));
        
        -- B[i] selection mux
        if(bi = '1') then
            mux_bi <= sum_a;
        else
            mux_bi <= result_bitshift;
        end if;
        
        -- Calculate the intermediate values
        sum_n   <= STD_LOGIC_VECTOR(unsigned(resize(signed(mux_bi), C_block_size+1)) - (resize(unsigned(n), C_block_size+1)));
        sum_2n  <= STD_LOGIC_VECTOR(unsigned(resize(signed(mux_bi), C_block_size+1)) - (unsigned(n_shifted)));
        mux_bi_underflow <= mux_bi(C_block_size);
        underflow1 <= sum_n(C_block_size);
        underflow2 <= sum_2n(C_block_size) or underflow1;
        
        -- Final selection mux
        if(underflow1 = '1' AND underflow2 = '1' AND mux_bi_underflow = '0') then
           result_nxt <= mux_bi(C_block_size - 1 downto 0);
        elsif(underflow1 = '0' AND underflow2 = '1') then
            result_nxt <= sum_n(C_block_size - 1 downto 0);
        elsif(underflow2 = '0' or (underflow1 = '1' AND underflow2 = '1' AND mux_bi_underflow = '1')) then
            result_nxt <= sum_2n(C_block_size - 1 downto 0);
        else
            result_nxt <= (others => '0');
        end if;
    end process;

    -- Output control signal
    process(counter)
    begin
        if (counter = std_logic_vector(to_unsigned(0, integer(ceil(log2(real(C_block_size))))))) then
            blakely_done_nxt <= '1';
        else
            blakely_done_nxt <= '0';
        end if;
    end process;
    
    result <= result_r;
    n_shifted <= STD_LOGIC_VECTOR(shift_left(resize(unsigned(n), C_block_size+1), 1));
    bi <= b(to_integer(unsigned(counter)));
    
end rtl;