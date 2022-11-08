library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scheduler is
    generic (
        Num_Cores           : integer := 2
    );
    port (
        -- clock and reset
        clk                 : in  std_logic;
        reset_n             : in  std_logic;
            
        -- Signals coming from rsa_top
        msgin_valid         : in  std_logic;
        msgin_ready         : out std_logic;
        
        -- Signals going to internal cores
        valid_in_vector     : out std_logic_vector(Num_Cores-1 downto 0);
        ready_in_vector     : in  std_logic_vector(Num_Cores-1 downto 0)
    );
end scheduler;

architecture rtl of scheduler is

signal valid_in_vector_r    : std_logic_vector (Num_Cores-1 downto 0);
signal msgin_ready_r        : std_logic;
signal valid_in_vector_nxt  : std_logic_vector (Num_Cores-1 downto 0);
signal msgin_ready_nxt      : std_logic;

begin
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            msgin_ready_r <= '0';
            valid_in_vector_r <= (others => '0');
        else
            if (rising_edge(clk)) then
                msgin_ready_r <= msgin_ready_nxt;
                valid_in_vector_r <= valid_in_vector_nxt;
            else
                msgin_ready_r <= msgin_ready_r;
                valid_in_vector_r <= valid_in_vector_r;
            end if;
        end if;
    end process;
    
    process(ready_in_vector, msgin_valid)
    begin
        --for i in 0 to Num_Cores-1 loop
        --    if ((ready_in_vector(i) = '1') and (ready_in_vector(0 to i-1) = std_logic_vector(to_unsigned(0, i-1)))) then
        --        valid_in_vector_nxt <= (i => msgin_valid, others => '0');
        --        msgin_ready_nxt <= ready_in_vector(i);
        --    end if;
        --end loop;*/

            if (ready_in_vector(0) = '1') then
                valid_in_vector_nxt <= (0 => msgin_valid, others => '0');
                msgin_ready_nxt <= ready_in_vector(0);
            elsif(ready_in_vector(1) = '1') then
                valid_in_vector_nxt <= (1 => msgin_valid, others => '0');
                msgin_ready_nxt <= ready_in_vector(1);
            else
                valid_in_vector_nxt <= (others => '0');
                msgin_ready_nxt <= '0';
            end if;
    end process;
    
    msgin_ready <= msgin_ready_r;
    valid_in_vector <= valid_in_vector_r;
    
end rtl;