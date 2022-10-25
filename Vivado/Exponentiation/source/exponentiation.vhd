library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

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
		nega_n    	: in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
		nega_2n 	: in STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is

-- Registers
signal P_r          : std_logic_vector(C_block_size-1 downto 0);
signal C_r          : std_logic_vector(C_block_size-1 downto 0);
signal P_nxt        : std_logic_vector(C_block_size-1 downto 0);
signal C_nxt        : std_logic_vector(C_block_size-1 downto 0);

-- PISO signals
signal bi           : STD_LOGIC;
signal store_M      : std_logic;
signal store_P      : std_logic;

-- Blakely signals
signal result_C        : std_logic_vector(C_block_size-1 downto 0);
signal result_P        : std_logic_vector(C_block_size-1 downto 0);

-- FSM signals
signal index        : unsigned(integer(ceil(log2(real(C_block_size))))-1 downto 0);

begin
    
    -- Instansiate PISO register
	/*in_PISO : entity work.PISO
	   generic map (
	       width => C_block_size
	   )
	   port map (
	       -- Inputs
	       clk => clk,
	       rst => reset_n,
	       store => store_M,
	       me_in => message,
	       
	       -- Outputs
	       data_out => bi
	   );*/
	   
	-- Instansiate Two Blakely modules
	in_blakely_C : entity work.blakely
	   generic map (
	       C_block_size => C_block_size
	   )
	   port map (
	       -- Inputs
	       clk => clk,
	       rst_n => reset_n,
	       a => C_r,
	       bi => bi,
	       nega_n => nega_n,
	       nega_2n => nega_2n,
	       -- Outputs
	       result => result_C
	   );
	   
	 in_blakely_P : entity work.blakely
	   generic map (
	       C_block_size => C_block_size
	   )
	   port map (
	       -- Inputs
	       clk => clk,
	       rst_n => reset_n,
	       a => P_r,
	       bi => bi,
	       nega_n => nega_n,
	       nega_2n => nega_2n,
	       -- Outputs
	       result => result_P
	   );
	
	
	-- Instansiate FSM
    in_FSM : entity work.FSM
        generic map (
            C_block_size => C_block_size
        )
        port map (
            -- Inputs
            valid_in => valid_in,
			ready_out => ready_out,
			clk => clk,
			rst_n => reset_n,
            -- Outputs
			valid_out => valid_out,
			ready_in => ready_in
        );
    
    -- Sequential datapath
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            C_r <= (others => '1');
			P_r <= (others => '0');
        elsif (rising_edge(clk)) then
            C_r <= C_nxt;

        end if;
    end process;
    
    -- Combinatorial datapath
    process(index)
    begin
        if (key(to_integer(index)) = '1') then
            C_nxt <= result_C;
        else 
            C_nxt <= C_r;
        end if;
    end process;
   
   bi <= P_r(to_integer(index));
   P_nxt <= result_P;
   result <= C_r;
   
end expBehave;
