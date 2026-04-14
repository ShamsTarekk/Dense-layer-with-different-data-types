library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;

entity Multfixed16 is 
    port(
        op1 : in sfixed(3 downto -12);
        op2 : in sfixed(3 downto -12);
        res : out sfixed(3 downto -12)
    );
end Multfixed16;

architecture Behavioral of Multfixed16 is
    signal temp : sfixed(7 downto -24);
begin

    temp <= op1 * op2;
    res <= resize(temp, res'high, res'low);

end Behavioral;
