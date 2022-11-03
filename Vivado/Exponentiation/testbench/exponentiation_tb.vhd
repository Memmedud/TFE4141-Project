library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity exponentiation_tb is 
end entity exponentiation_tb;

architecture blakely_tb_behave of exponentiation_tb is

    constant C_block_size   : integer := 256;
    
    -- clock and reset
    constant clk_period     : time := 10 ns;
    signal clk              : STD_LOGIC := '0';
    signal rst_n            : STD_LOGIC := '0';

    -- Exponentiation signals
    signal valid_in         : std_logic;
    signal ready_in         : std_logic;
    signal ready_out        : std_logic;
    signal valid_out        : std_logic;
    signal message          : std_logic_vector(C_block_size-1 downto 0);
    signal key              : std_logic_vector(C_block_size-1 downto 0);
    signal n                : std_logic_vector(C_block_size-1 downto 0);
    signal result           : std_logic_vector(C_block_size-1 downto 0);

    -- Control signals
    signal expected : std_logic_vector(C_block_size-1 downto 0);    
    
    -----------------------------------------------------------------------------
    -- Function for converting from hex strings to std_logic_vector.
    -----------------------------------------------------------------------------
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

	-----------------------------------------------------------------------------
	-- Function for converting from std_logic_vector to a string.
	-----------------------------------------------------------------------------
	function stdvec_to_string ( inp1: std_logic_vector) return string is
		variable p : string (inp1'length/4 downto 1) := (others => NUL);
		variable nibble : std_logic_vector(3 downto 0);
	begin
		for i in p'length downto 1 loop
			nibble := inp1(i*4-1 downto (i-1)*4);
			case nibble is
				when "0000" => p(i) := '0';
				when "0001" => p(i) := '1';
				when "0010" => p(i) := '2';
				when "0011" => p(i) := '3';
				when "0100" => p(i) := '4';
				when "0101" => p(i) := '5';
				when "0110" => p(i) := '6';
				when "0111" => p(i) := '7';
				when "1000" => p(i) := '8';
				when "1001" => p(i) := '9';
				when "1010" => p(i) := 'A';
				when "1011" => p(i) := 'B';
				when "1100" => p(i) := 'C';
				when "1101" => p(i) := 'D';
				when "1110" => p(i) := 'E';
				when "1111" => p(i) := 'F';
				when others => p(i) := 'X';
			end case;
		end loop;
		return p;
	end function;
	
    
begin

	-- Testbench procedure
    process
    begin
      
        report "********************************************************************************";
        report "STARTING FIRST TESTCASE";
        report "********************************************************************************";
            
        -- Set up input signals
        n <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d"; --str_to_stdvec("99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d");
        a <= x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01"; --str_to_stdvec("85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");
        b <= x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01"; --str_to_stdvec("85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");
        expected <= x"80291d6bcaeec4accc8cadf9dcc350b3c13dad526cec43bdb3d72f2d4628f697"; --str_to_stdvec("80291d6bcaeec4accc8cadf9dcc350b3c13dad526cec43bdb3d72f2d4628f697");
        
        -- Waiting for different stuff
        wait until rst_n = '1';
        wait until rising_edge(clk);
        blakely_enable <= '1';
        wait until blakely_done = '1';
        wait until rising_edge(clk);
        blakely_enable <= '0';

        -- Check the result;
        assert (result = expected)
            report "Output message differs from the expected result"
            severity Failure;
            
        report "********************************************************************************";
        report "STARTING NEXT TESTCASE";
        report "********************************************************************************";
            
        -- Set up input signals
        n <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d"; --str_to_stdvec("99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d");
        a <= x"0a23232323232323232323232323232323232323232323232323232323232323"; --str_to_stdvec("85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");
        b <= x"0a23232323232323232323232323232323232323232323232323232323232323"; --str_to_stdvec("85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");
        expected <= x"24931802b9ead447563ec7f0f3d613270a5dd5f3d3df1457b9857de14da1a750"; --str_to_stdvec("80291d6bcaeec4accc8cadf9dcc350b3c13dad526cec43bdb3d72f2d4628f697");
           
        -- Waiting for different stuff
        wait until rising_edge(clk);
        blakely_enable <= '1';
        wait until blakely_done = '1';
        wait until rising_edge(clk);
        blakely_enable <= '0';

        -- Check the result;
        assert (result = expected)
            report "Output message differs from the expected result"
            severity Failure;
    
        -- Report done and wait forever
        assert true;
            report "********************************************************************************";
            report "ALL TESTS FINISHED SUCCESSFULLY";
            report "********************************************************************************";
        
    end process;
	
	-- clock generation 
    clk_gen: process is
	begin
		clk <= '1';
		wait for clk_period / 2;
		clk <= '0';
		wait for clk_period / 2;
	end process;
    
    -- reset_n generator
    reset_gen: process is
    begin
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
        wait;
    end process;
   
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
        n               => n,
        blakely_enable  => blakely_enable,

        result          => result,
        blakely_done    => blakely_done
    );

end blakely_tb_behave;