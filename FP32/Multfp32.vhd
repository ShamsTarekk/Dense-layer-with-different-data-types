library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.float_pkg.all;
use work.fixed_float_types.all;
entity Multfp32 is 
port(
op1,op2: in float32;
         res: out float32);
end Multfp32;
architecture Behavioral of Multfp32 is
begin

res<=op1*op2;


end Behavioral;