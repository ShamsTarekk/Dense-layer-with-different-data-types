library ieee;
use ieee.std_logic_1164.all;
use work.float_pkg.all;  

package float_vector_pkg is

    type float16_array is array (natural range <>) of float16;
    type float32_arrayy is array (natural range <>) of float32;
    type float64_array is array (natural range <>) of float64;
    type float32_2d_array is array (natural range <>, natural range <>) of float32;
    type float64_2d_array is array (natural range <>, natural range <>) of float64;
    type float16_2d_array is array (natural range <>, natural range <>) of float16;

end package;
package body float_vector_pkg is
end package body;
