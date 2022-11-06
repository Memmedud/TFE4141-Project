--------------------------------------------------------------------------------
-- Author       : Oystein Gjermundnes
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2018-2019
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
-- Purpose:
--   RSA encryption core, it implements the function
--   C = M**key_e mod key_n.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rsa_core is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          : integer := 256;
		-- Number of Exponentiation cores to instanciate
		Num_Cores             : integer := 2
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in std_logic;
		reset_n                :  in std_logic;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             :  in std_logic;
		-- Slave ready to accept a new message
		msgin_ready             : out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last              :  in std_logic;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out std_logic;
		-- Slave ready to accept a new message
		msgout_ready            :  in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last             : out std_logic;

		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n                   :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status              : out std_logic_vector(31 downto 0)

	);
end rsa_core;

architecture rtl of rsa_core is
    
    -- Creates a matrix used for msgout-mux
    type t_matrix is array (0 to Num_Cores-1) of std_logic_vector(C_BLOCK_SIZE-1 downto 0);
    signal msgout_vector            : t_matrix;

    signal last_message             : std_logic;
    
    signal valid_in_vector          : std_logic_vector(Num_Cores-1 downto 0);
    signal valid_out_vector         : std_logic_vector(Num_Cores-1 downto 0);
    signal ready_in_vector          : std_logic_vector(Num_Cores-1 downto 0);
    signal ready_out_vector         : std_logic_vector(Num_Cores-1 downto 0);

    signal ready_in_internal        : std_logic_vector(Num_Cores-1 downto 0);  
    
    
    signal test : std_logic;   
begin
    
    -- Generates Num_Cores number of RSA cores
    Cores : for i in 0 to Num_Cores-1 generate
    begin
        i_exponentiation : entity work.exponentiation
		generic map (
			C_block_size => C_BLOCK_SIZE
		)
		port map (
		    -- Signals equal for all instanciations			
			clk       => clk         ,
			reset_n   => reset_n     ,
			n         => key_n       ,
			key       => key_e_d     ,
			message   => msgin_data  ,
			
			-- Individual signals
			valid_in  => valid_in_vector(i) ,
			ready_in  => ready_in_vector(i) ,
			ready_out => ready_out_vector(i),
			valid_out => valid_out_vector(i),
			result    => msgout_vector(i) 
		);	   
    end generate Cores;
    
    -- Other minor logic
	msgout_last  <= last_message and msgout_valid;     -- This is probably wrong
	rsa_status   <= (others => '0');                   -- Maybe something interesting to do with this?
	msgin_ready <= (or ready_in_vector);
	--ready_in_vector(0) <= '0';
	
	
	-- Generate internal ready_in signals
	process(ready_in_vector, ready_in_internal)
	begin
	   ready_in_internal(0) <= '0';
	   for i in 0 to Num_Cores-2 loop
	       ready_in_internal(i+1) <= ready_in_vector(i) or ready_in_internal(i);
	   end loop;
	end process;
	
	process(ready_in_vector, ready_in_internal)
	begin
	   for i in 0 to Num_Cores-1 loop
	       valid_in_vector(i) <= (not ready_in_internal(i)) and ready_in_vector(i) and test;
	   end loop;
	end process;	
	
	process(clk, reset_n)
	begin
	   if (reset_n = '0') then
	       last_message <= '0';
	   else
	       if (msgin_valid = '1' and msgin_ready = '1') then
	           last_message <= msgin_last;
	       else
	           last_message <= last_message;
	       end if;
	   end if;
	end process;
	
	test <= msgin_valid;
	
end rtl;
