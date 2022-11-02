library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blakely_tb is 
    generic (
        C_block_size : integer := 256
    );
end entity blakely_tb;

architecture blakely_tb_behave of blakely_tb is
    -- clock and reset
    constant clk_period     : time := 10 ns;
    signal clk              : STD_LOGIC;
    signal rst_n            : STD_LOGIC;

    -- Blakely signals
    signal a                : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal b                : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal bi               : STD_LOGIC; 
    signal n                : STD_LOGIC_VECTOR(C_block_size-1 downto 0)
    signal nega_n           : STD_LOGIC_VECTOR(C_block_size-1 downto 0)
    signal nega_2n          : STD_LOGIC_VECTOR(C_block_size-1 downto 0)
    signal blakely_enable   : STD_LOGIC;
    signal result           : STD_LOGIC_VECTOR (C_block_size-1 downto 0);
    signal blakely_done     : STD_LOGIC;

    -- FSM signals
    type states is (LOAD, WAIT, VALIDATE);
    signal tb_state         : states := LOAD;
    signal tb_state_nxt     : states := LOAD;

begin

    -- Instance of Blakely module (DUT)
    i_blakely : entity work.blakely
    generic map (
        C_block_size => C_block_size
    )
    port map (
        clk             => clk,
        rst_n           => rst_n,

        a               => a,
        b               => b,
        nega_n          => nega_n,
        nega_2n         => nega_2n,
        blakely_enable  => blakely_enable,

        result          => result,
        blakely_done    => blakely_done
    )

-- clock generation 
clk <= not clk after clk_period / 2;

-- reset_n generator
reset_gen: process is
begin
    reset_n <= '0';
    wait for 20 ns;
    reset_n <= '1';
    wait;
end process;

-- Generate negative n
nega_n <= STD_LOGIC_VECTOR(-signed(n));
nega_n <= STD_LOGIC_VECTOR(-signed(shift_left(n, 1)));

-- Function for converting std_vector to string
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

-- Function for converting string to std_vector
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

procedure is
begin
    report "********************************************************************************";
	report "STARTING NEW TESTCASE";
	report "********************************************************************************";
    
    -- Set up input signals
    n <= str_to_stdvec("99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d");
    a <= str_to_stdvec("85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");
    b <= str_to_stdvec("85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");
    variable expected := str_to_stdvec("171d075bdfd834ddf0433a8092d9fb9b823c353b651d89fea0079588538cbb8a")
    
    -- Waiting for different stuff
    wait until rst_n = '1';
    wait until rising_edge(clk);
    blakely_enable <= '1';
    wait until blakely_done = '1';

    -- Check the result;
    assert (result = expected)
        report "Output message differs from the expected result"
		everity Failure;

    -- Report done and wait forever
    report "********************************************************************************";
	report "ALL TESTS FINISHED SUCCESSFULLY";
	report "********************************************************************************";
    wait;
end procedure;

/*
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
        */
end blakely_tb_behave;


