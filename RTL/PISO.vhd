-- Parallel in, serial out shift register
-- LSB first, towards MSB

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PISO is
    generic (
        width: integer := 256  -- Width of parallel port 
    );

    port (
        -- Inputs
        clk         : in std_logic;
        rst         : in std_logic;
        store       : in std_logic;
        data_in     : in std_logic_vector((width-1) downto 0); 
        
        -- Outputs
        data_out    : out std_logic
    );
end PISO;

architecture rtl of PISO is

signal reg : unsigned((width-1) downto 0);

begin
    piso_pr: process(clk, rst, data_in, store, reg)
    begin
        if (rst = '1') then
            reg <= (others => '0');
        elsif (rising_edge(clk)) then
            if (store = '1') then
                reg <= unsigned(data_in);
            else
                reg <= shift_right(reg, 1);
            end if;
        end if;
    end process;
    
    data_out <= reg(0);
    
end rtl;