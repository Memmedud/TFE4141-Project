library IEEE;
use IEEE.std_logic_1164.all;

entity ModMul is
    generic (
        width: integer := 256  -- Width of parallel port 
    );

    port (
        -- Inputs
        clk             : in std_logic;
        rst             : in std_logic;
        a               : in std_logic_vector((width - 1) downto 0);
        b               : in std_logic_vector((width - 1) downto 0);
        n_neg           : in std_logic_vector((width - 1) downto 0);
        n_2neg          : in std_logic_vector((width - 1) downto 0);

        -- Outputs
        result          : out std_logic_vector((width - 1) downto 0);
        result_ready    : out std_logic;
    );
end ModMul;

architecture rtl of ModMul is

signal bi : std_logic;
signal result_next : std_logic_vector((width - 1) downto 0);
signal result1 : std_logic_vector((width - 1) downto 0);
signal result2 : std_logic_vector((width - 1) downto 0);
signal result3 : std_logic_vector((width) downto 0);
signal result4 : std_logic_vector((width) downto 0);

begin
    PISO_i : entity work.PISO   -- Instance of the PISO shift register
        generic map (
            width => width;
        )
        port map (
            clk => clk,
            rst => rst,

            data_in => b,
            data_out => bi
        );
    
    -- Sequential datapath
    process(clk, rst)
    begin
        if (rst = '1') then
            result <= (others => '0');
        elsif (rising_edge(clk)) then
            result <= result_next;
        end if;
    end process;

    -- Combinatorial datapath
    process(a, b, n_neg, n_2neg, result, result1, result2, result3, result4)
    begin
        result1 <= result << 1;

        if (bi = '1') then
            result2 <= result1 + a;
        else 
            result2 <= result1;
        end if;

        result3 <= result2 + n_neg;
        result4 <= result2 + n_2neg;

        result_next <= result2 when result3(width) = '1' and result4(width) = '1' else
                       result3 when result3(width) = '0' and result4(width) = '1' else
                       result4 when result4(width) = '0' else
                       others => '0';
    end process;        
    
end rtl;