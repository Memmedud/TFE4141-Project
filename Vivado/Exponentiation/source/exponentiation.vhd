library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		-- clock and reset
		clk 		: in std_logic;
		reset_n 	: in std_logic;

		-- control signals
		valid_in	: in  std_logic;
		ready_in	: out std_logic;
		ready_out	: in  std_logic;
		valid_out	: out std_logic;
		msgin_last  : in  std_logic;
		msgout_last : out std_logic;

		-- input data
		message 	: in std_logic_VECTOR(C_block_size-1 downto 0);
		key 		: in std_logic_VECTOR(C_block_size-1 downto 0);
		n    	    : in std_logic_VECTOR(C_block_size-1 downto 0);
		
		-- output data
		result 		: out std_logic_VECTOR(C_block_size-1 downto 0)
	);
end exponentiation;


architecture expBehave of exponentiation is

-- Registers
signal P_r              : std_logic_vector(C_block_size-1 downto 0);
signal C_r              : std_logic_vector(C_block_size-1 downto 0);
signal P_nxt            : std_logic_vector(C_block_size-1 downto 0);
signal C_nxt            : std_logic_vector(C_block_size-1 downto 0);
signal msg_last_r       : std_logic;

-- Blakely signals
signal result_C     	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
signal result_P     	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
signal e_i              : STD_LOGIC;
signal b_i				: STD_LOGIC;

signal blakely_counter  : STD_LOGIC_VECTOR(integer(ceil(log2(real(C_block_size))))-1 downto 0);
signal blakely_done_nxt : STD_LOGIC;
signal blakely_done 	: STD_LOGIC;
signal blakely_enable	: STD_LOGIC;

-- FSM signals
signal e_index          : STD_LOGIC_VECTOR(integer(ceil(log2(real(C_block_size))))-1 downto 0);

begin  
	--------------------------------------- 
	-- Instansiate Two Blakely modules
	---------------------------------------
	in_blakely_C : entity work.blakely
	   	generic map (
	       	C_block_size => C_block_size
	   	)
	   	port map (
	       	-- Inputs
	       	clk 			=> clk,
	       	rst_n 			=> reset_n,
	       	a 				=> C_r,
			b_i				=> b_i,
	       	n 				=> n,
		   	blakely_enable 	=> blakely_enable,

	       	-- Outputs
	       	result 			=> result_C
	   );
	   
	in_blakely_P : entity work.blakely
	   	generic map (
	       C_block_size => C_block_size
	   	)
	   	port map (
	        -- Inputs
	        clk 			=> clk,
	        rst_n 			=> reset_n,
	        a 				=> P_r,
			b_i				=> b_i,
	        n 				=> n,
			blakely_enable  => blakely_enable,
	        
			-- Outputs
	        result 			=> result_P
	   );

	---------------------------------------
	-- FSM
	---------------------------------------
	in_FSM : entity work.FSM
			generic map(
				C_block_size => C_block_size
			)
			port map (
				-- Inputs
				clk				=> clk,
				rst_n			=> reset_n,
				valid_in		=> valid_in,
				ready_out		=> ready_out,
				blakely_done	=> blakely_done,

				-- Outputs
				valid_out		=> valid_out,
				ready_in		=> ready_in,
				blakely_enable	=> blakely_enable,
				e_index			=> e_index
			);

			
	---------------------------------------
    -- Clock data into registers
	---------------------------------------
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            C_r <= (0 => '1', others => '0');
			P_r <= (others => '0');
        elsif (rising_edge(clk)) then
            C_r <= C_nxt;
            P_r <= P_nxt;
        end if;
    end process;


	---------------------------------------
	--Control msg_last
	---------------------------------------
	process(clk, reset_n)
	begin
		if (reset_n = '0') then
			msg_last_r <= '0';
		elsif (rising_edge(clk)) then
			if (valid_in = '1') then
            	msg_last_r <= msgin_last;
        	else 
            	msg_last_r <= msg_last_r;
			end if;
        end if;
	end process;
    

	---------------------------------------
    -- Combinatorial datapath
	---------------------------------------
    process(e_index, key, result_C, C_r, valid_in, message, ready_in, blakely_done, result_P, P_r, e_i)
    begin
        if (ready_in = '1' and valid_in = '1') then
            C_nxt <= (0 => '1', others => '0');
            P_nxt <= message;
        else
            if (blakely_done = '1') then
                if(e_i = '1') then
                    C_nxt <= result_C;
                    P_nxt <= result_P;
                else 
                    C_nxt <= C_r;
                    P_nxt <= result_P;
                end if;
            else
                C_nxt <= C_r;
                P_nxt <= P_r;
            end if;
        end if;
    end process;


	---------------------------------------
	-- Blakely counter
	---------------------------------------
	process(clk, reset_n)
	begin
		if (reset_n = '0') then
			blakely_counter <= (others => '1');
			blakely_done <= '0';
		elsif (rising_edge(clk) ) then
		 	if (blakely_enable = '1') then
				blakely_counter <= std_logic_vector(unsigned(blakely_counter) - 1);
				blakely_done <= blakely_done_nxt;
			else
				blakely_counter <= (others => '1');
				blakely_done <= '0';
			end if;
		end if;
	end process;

	process(blakely_counter)
    begin
        if (blakely_counter = std_logic_vector(to_unsigned(0, integer(ceil(log2(real(C_block_size))))))) then
            blakely_done_nxt <= '1';
        else
            blakely_done_nxt <= '0';
        end if;
    end process;


    msgout_last <= msg_last_r;
    result <= C_r;

	e_i <= (key(to_integer(unsigned(e_index))));
	b_i <= P_r(to_integer(unsigned(blakely_counter)));

    
end expBehave;
