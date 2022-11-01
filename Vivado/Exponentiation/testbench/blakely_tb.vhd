library ieee;
use ieee.std_logic_1164.all;


entity blakely_tb is 
    generic (
        C_block_size : integer := 256
    );
end entity blakely_tb;

architecture blakelyBehave of blakely_tb is
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

-- clock generation 
clk <= not clk after clk_period / 2;

function stdvec_to_string ( a: std_logic_vector) return string is
    variable b : string (a'length/4 downto 1) := (others => NUL);
    variable nibble : std_logic_vector(3 downto 0);
begin
    for i in b'length downto 1 loop
        nibble := a(i*4-1 downto (i-1)*4);
        case nibble is
            when "0000" => b(i) := '0';
            when "0001" => b(i) := '1';
            when "0010" => b(i) := '2';
            when "0011" => b(i) := '3';
            when "0100" => b(i) := '4';
            when "0101" => b(i) := '5';
            when "0110" => b(i) := '6';
            when "0111" => b(i) := '7';
            when "1000" => b(i) := '8';
            when "1001" => b(i) := '9';
            when "1010" => b(i) := 'A';
            when "1011" => b(i) := 'B';
            when "1100" => b(i) := 'C';
            when "1101" => b(i) := 'D';
            when "1110" => b(i) := 'E';
            when "1111" => b(i) := 'F';
            when others => b(i) := 'X';
        end case;

    end loop;
    return b;
end function;

function str_to_stdvec(inp: string) return std_logic_vector is
    variable temp: std_logic_vector(4*inp'length-1 downto 0) := (others => 'X');
    variable temp1 : std_logic_vector(3 downto 0);
begin
    for i in inp'range loop
        case inp(i) is
             when '0' =>	 temp1 := x"0";
             when '1' =>	 temp1 := x"1";
             when '2' =>	 temp1 := x"2";
             when '3' =>	 temp1 := x"3";
             when '4' =>	 temp1 := x"4";
             when '5' =>	 temp1 := x"5";
             when '6' =>	 temp1 := x"6";
             when '7' =>	 temp1 := x"7";
             when '8' =>	 temp1 := x"8";
             when '9' =>	 temp1 := x"9";
             when 'A'|'a' => temp1 := x"a";
             when 'B'|'b' => temp1 := x"b";
             when 'C'|'c' => temp1 := x"c";
             when 'D'|'d' => temp1 := x"d";
             when 'E'|'e' => temp1 := x"e";
             when 'F'|'f' => temp1 := x"f";
             when others =>  temp1 := "XXXX";
        end case;
        temp(4*(i-1)+3 downto 4*(i-1)) := temp1;
    end loop;
    return temp;
end function str_to_stdvec;

-- case 1 
procedure case1(
    -- signal list
    result, result_nxt 
)is 
    -- var list 
    variable temp   :   integer;
begin
    a   <= (others => '0');
    bi  <= 0; 
    result_r <= result_nxt;
    -- wait for 5*clk_period; 
    temp <= to_integer(a);
    report "The value of a is" & integer'image(a);  -- prints a if a is an integer
end case1;

procedure case2(
    result, result
)


-- testcase 
    testcase_1 : process(clk)
        begin
             

        end process
        
end blakelyBehave;


