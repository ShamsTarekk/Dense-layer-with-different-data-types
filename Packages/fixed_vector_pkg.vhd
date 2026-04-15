library ieee;
use ieee.std_logic_1164.all;
use work.fixed_pkg.all;  

package fixed_vector_pkg is

--   subtype fixed8  is sfixed(0 downto -7);
   subtype fixed8  is sfixed(3 downto -4);
   subtype fixed16 is sfixed(3 downto -12);
   
   type fixed8_array is array (natural range <>) of fixed8;
   type fixed16_array is array (natural range <>) of fixed16;
   type fixed8_2d_array is array (natural range <>, natural range <>) of fixed8;
   type fixed16_2d_array is array (natural range <>, natural range <>) of fixed16;
    
end package;

package body fixed_vector_pkg is
    -- empty
end package body;
