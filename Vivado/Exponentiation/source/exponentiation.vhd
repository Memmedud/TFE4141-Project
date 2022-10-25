library ieee;
use ieee.std_logic_1164.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input control
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		message 	: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		key 		: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );

		--ouput control
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--output data
		result 		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		modulus 	: in STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is

signal bi           : STD_LOGIC;

begin
    
    -- Instansiate PISO register
	in_PISO : entity work.PISO
	   generic map (
	       width => C_block_size
	   )
	   port map (
	       clk => clk,
	       rst => reset_n,
	       store => '1',
	       data_in => message,
	       
	       data_out => bi
	   );
	   
	-- Instansiate Two Blakely modules
	in_blakely : entity work.
	
	
	-- Instansiate FSM
    
    
    
	process
	
	begin
	
	end process;
end expBehave;
