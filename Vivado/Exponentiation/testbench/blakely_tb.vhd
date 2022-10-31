library ieee;
use ieee.std_logic_1164.all;


entity blakely_tb is 
    generic (
        C_block_size : integer := 256
    );
end entity blakely_tb;

architecture blakleyBehave of blakely_tb is
    constant clk_period : time := 5 ns;

    signal result       : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal a            : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal b            : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal bi           : STD_LOGIC; 
    signal nega_n       : STD_LOGIC;
    signal nega_2n      : STD_LOGIC;
    signal result_nxt   : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal result_r     : STD_LOGIC_VECTOR (C_block_size-1 downto 0);

begin
    i_blakely : entity work.blakely
        port map (
            
        )

-- case 1 
procedure case1(
    -- signal list
    result, result_nxt 
)is 
    -- var list 
begin
    a   <= 0;
    bi  <= 0; 
    result_r <= result_nxt;
    report "The value of a is" & integer'image(a);  -- prints a if a is an integer
end case1;

        
end blakelyBehave;


