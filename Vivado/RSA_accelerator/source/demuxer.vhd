library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demuxer is
    generic (
        Num_Cores               : integer := 2
    );
    port (
        -- clock and reset
        clk                 : in  std_logic;
        reset_n             : in  std_logic;
        
        -- Signals going to rsa_top
        msgout_valid        : out  std_logic;
        msgout_ready        : in std_logic;
        msgout_select       : out std_logic_vector(Num_Cores-1 downto 0);
        
        -- Signals coming from internal cores
        valid_out_vector    : out std_logic_vector(Num_Cores-1 downto 0);
        ready_out_vector    : in  std_logic_vector(Num_Cores-1 downto 0)
    );
end demuxer;

architecture rtl of demuxer is

signal valid_out_vector_r   : std_logic_vector(Num_Cores-1 downto 0);
signal msgout_ready_r       : std_logic;
signal valid_out_vector_nxt : std_logic_vector(Num_Cores-1 downto 0);
signal msgout_ready_nxt     : std_logic;

begin
    process(clk, reset_n)
    begin
    
    end process;
    
    
end rtl;