library IEEE;
use work.float_pkg.all;
use work.fixed_float_types.all;
entity Multfp16 is port(op1,op2: in float16;
                     res: out float16);
end Multfp16;
architecture Behavioral of Multfp16 is
begin
res<=op1*op2;


end Behavioral;