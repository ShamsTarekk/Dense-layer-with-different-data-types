library IEEE;
use work.float_pkg.all;
use work.fixed_float_types.all;
entity Multfp64 is port(op1,op2: in float64;
                     res: out float64);
end Multfp64;
architecture Behavioral of Multfp64 is
begin
res<=op1*op2;


end Behavioral;