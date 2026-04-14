-- Dense_fp64
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.float_pkg.all;
use work.fixed_pkg.all;
use work.fixed_float_types.all;
use work.float_vector_pkg.all;

entity Dense_fp64 is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        in_vec  : in  float64_array(0 to 63);
        weights : in  float64_2d_array(0 to 63, 0 to 9);
        bias    : in  float64_array(0 to 9);
        out_vec : out float64_array(0 to 9);
        max_addr : out std_logic_vector(3 downto 0)
    );
end Dense_fp64;

architecture Behavioral of Dense_fp64 is

    type mo is array (0 to 63, 0 to 9) of float64;

    signal mult_output : mo;
    signal acc_output  : float64_array(0 to 9);

    component Multfp64 is
        port (
            op1, op2 : in float64;
            res : out float64
        );
    end component;

    component Accumulatorfp64 is
        port (
            acc1,acc2,acc3,acc4,acc5,acc6,acc7,acc8,
            acc9,acc10,acc11,acc12,acc13,acc14,acc15,acc16,
            acc17,acc18,acc19,acc20,acc21,acc22,acc23,acc24,
            acc25,acc26,acc27,acc28,acc29,acc30,acc31,acc32,
            acc33,acc34,acc35,acc36,acc37,acc38,acc39,acc40,
            acc41,acc42,acc43,acc44,acc45,acc46,acc47,acc48,
            acc49,acc50,acc51,acc52,acc53,acc54,acc55,acc56,
            acc57,acc58,acc59,acc60,acc61,acc62,acc63,acc64,
            bias    : in float64;
            res     : out float64
        );
    end component;

    component getting_Address_of_maxfp64 is
        port (
            clk : in std_logic;
            act1,act2,act3,act4,act5,act6,act7,act8,act9,act10 : in float64;
            address : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    GEN_MUL: for y in 0 to 9 generate
        GEN_MUL_ROW: for i in 0 to 63 generate
            M: Multfp64
                port map(
                    op1 => weights(i, y),
                    op2 => in_vec(i),
                    res => mult_output(i, y)
                );
        end generate;
    end generate;

    GEN_ACC: for k in 0 to 9 generate
        A: Accumulatorfp64
            port map(
                acc1  => mult_output(0,k),  acc2  => mult_output(1,k),
                acc3  => mult_output(2,k),  acc4  => mult_output(3,k),
                acc5  => mult_output(4,k),  acc6  => mult_output(5,k),
                acc7  => mult_output(6,k),  acc8  => mult_output(7,k),
                acc9  => mult_output(8,k),  acc10 => mult_output(9,k),

                acc11 => mult_output(10,k), acc12 => mult_output(11,k),
                acc13 => mult_output(12,k), acc14 => mult_output(13,k),
                acc15 => mult_output(14,k), acc16 => mult_output(15,k),
                acc17 => mult_output(16,k), acc18 => mult_output(17,k),
                acc19 => mult_output(18,k), acc20 => mult_output(19,k),

                acc21 => mult_output(20,k), acc22 => mult_output(21,k),
                acc23 => mult_output(22,k), acc24 => mult_output(23,k),
                acc25 => mult_output(24,k), acc26 => mult_output(25,k),
                acc27 => mult_output(26,k), acc28 => mult_output(27,k),
                acc29 => mult_output(28,k), acc30 => mult_output(29,k),

                acc31 => mult_output(30,k), acc32 => mult_output(31,k),
                acc33 => mult_output(32,k), acc34 => mult_output(33,k),
                acc35 => mult_output(34,k), acc36 => mult_output(35,k),
                acc37 => mult_output(36,k), acc38 => mult_output(37,k),
                acc39 => mult_output(38,k), acc40 => mult_output(39,k),

                acc41 => mult_output(40,k), acc42 => mult_output(41,k),
                acc43 => mult_output(42,k), acc44 => mult_output(43,k),
                acc45 => mult_output(44,k), acc46 => mult_output(45,k),
                acc47 => mult_output(46,k), acc48 => mult_output(47,k),
                acc49 => mult_output(48,k), acc50 => mult_output(49,k),

                acc51 => mult_output(50,k), acc52 => mult_output(51,k),
                acc53 => mult_output(52,k), acc54 => mult_output(53,k),
                acc55 => mult_output(54,k), acc56 => mult_output(55,k),
                acc57 => mult_output(56,k), acc58 => mult_output(57,k),
                acc59 => mult_output(58,k), acc60 => mult_output(59,k),

                acc61 => mult_output(60,k), acc62 => mult_output(61,k),
                acc63 => mult_output(62,k), acc64 => mult_output(63,k),

                bias => bias(k),
                res  => acc_output(k)
            );
    end generate;

    out_vec <= acc_output;

    GET_MAX: getting_Address_of_maxfp64
        port map (
            clk => clk,
            act1 => acc_output(0), act2 => acc_output(1),
            act3 => acc_output(2), act4 => acc_output(3),
            act5 => acc_output(4), act6 => acc_output(5),
            act7 => acc_output(6), act8 => acc_output(7),
            act9 => acc_output(8), act10 => acc_output(9),
            address => max_addr
        );

end Behavioral;
