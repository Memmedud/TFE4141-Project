
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BlakelyComb is
    generic (
        width: integer := 256  -- Width of data 
    );

    port (
        -- Inputs
        R_r         : in std_logic_vector((width-1) downto 0);
        A           : in std_logic_vector((width-1) downto 0);   
        n           : in std_logic_vector((width-1) downto 0); 
        Bi          : in std_logic;

        -- Outputs
        R_next      : out std_logic_vector((width-1) downto 0);
    );
end BlakelyComb;

architecture rtl of BlakelyComb is

signal 

begin
    BlakelyComb_pr: process()
    begin
        R_next <= shift_right(R_r, 1) when Bi = '0' and ... else
                  shift
    end process;

end rtl;