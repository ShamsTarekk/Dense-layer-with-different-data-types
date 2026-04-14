library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;

entity Accumulatorfixed16 is
    port (
        acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8,
        acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16,
        acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24,
        acc25, acc26, acc27, acc28, acc29, acc30, acc31, acc32,
        acc33, acc34, acc35, acc36, acc37, acc38, acc39, acc40,
        acc41, acc42, acc43, acc44, acc45, acc46, acc47, acc48,
        acc49, acc50, acc51, acc52, acc53, acc54, acc55, acc56,
        acc57, acc58, acc59, acc60, acc61, acc62, acc63, acc64 : in sfixed(3 downto -12);
        bias : in sfixed(3 downto -12);
        res  : out sfixed(3 downto -12)
    );
end Accumulatorfixed16;

architecture Behavioral of Accumulatorfixed16 is

    -- Internal accumulator width (safe for 64 sums)
    subtype wide is sfixed(13 downto -24);  -- 14 integer bits + 25 fraction bits
    signal sumv : wide;

    -- Helper function to widen inputs to accumulator width
    function W(x : sfixed(3 downto -12)) return wide is
    begin
        return resize(x, wide'high, wide'low);
    end function;

    -- Array of inputs to simplify accumulation
    type input_array is array(0 to 63) of sfixed(3 downto -12);
    signal acc_inputs : input_array;

begin

    -- map individual ports into an array
    acc_inputs <= ( acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8,
                    acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16,
                    acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24,
                    acc25, acc26, acc27, acc28, acc29, acc30, acc31, acc32,
                    acc33, acc34, acc35, acc36, acc37, acc38, acc39, acc40,
                    acc41, acc42, acc43, acc44, acc45, acc46, acc47, acc48,
                    acc49, acc50, acc51, acc52, acc53, acc54, acc55, acc56,
                    acc57, acc58, acc59, acc60, acc61, acc62, acc63, acc64 );

    -- accumulation process
    process(acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8,
                        acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16,
                        acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24,
                        acc25, acc26, acc27, acc28, acc29, acc30, acc31, acc32,
                        acc33, acc34, acc35, acc36, acc37, acc38, acc39, acc40,
                        acc41, acc42, acc43, acc44, acc45, acc46, acc47, acc48,
                        acc49, acc50, acc51, acc52, acc53, acc54, acc55, acc56,
                        acc57, acc58, acc59, acc60, acc61, acc62, acc63, acc64 ,bias)
        variable tmp_sum : wide := (others => '0');
    begin
        tmp_sum := (others => '0');

        for i in 0 to 63 loop
            tmp_sum := resize(tmp_sum + W(acc_inputs(i)), wide'high, wide'low);
        end loop;

        -- add bias
        tmp_sum := resize(tmp_sum + W(bias), wide'high, wide'low);

        -- resize back to fixed16 for output
        res <= resize(tmp_sum, 3, -12);
    end process;

end Behavioral;
