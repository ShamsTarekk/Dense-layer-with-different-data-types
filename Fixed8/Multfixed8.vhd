library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;

entity Multfixed8 is 
    port(
        op1 : in sfixed(3 downto -4);
        op2 : in sfixed(3 downto -4);
        res : out sfixed(3 downto -4)
    );
end Multfixed8;

architecture Behavioral of Multfixed8 is
    signal temp : sfixed(7 downto -8); 
begin

    temp <= op1 * op2;
    res <= resize(temp, 3, -4);

end Behavioral;
