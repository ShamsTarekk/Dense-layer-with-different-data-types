
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.float_pkg.all;
use work.fixed_float_types.all;

entity Accumulatorfp16 is
  Port (acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16, acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24, acc25, acc26, acc27, acc28, acc29, acc30, acc31, acc32, acc33, acc34, acc35, acc36, acc37, acc38, acc39, acc40, acc41, acc42, acc43, acc44, acc45, acc46, acc47, acc48, acc49, acc50, acc51, acc52, acc53, acc54, acc55, acc56, acc57, acc58, acc59, acc60, acc61, acc62, acc63, acc64,bias:in float16;
        res:out float16);
end Accumulatorfp16;

architecture Behavioral of Accumulatorfp16 is

begin
res <= acc1 + acc2 + acc3 + acc4 + acc5 + acc6 + acc7 + acc8 + acc9 + acc10 +
       acc11 + acc12 + acc13 + acc14 + acc15 + acc16 + acc17 + acc18 + acc19 + acc20 +
       acc21 + acc22 + acc23 + acc24 + acc25 + acc26 + acc27 + acc28 + acc29 + acc30 +
       acc31 + acc32 + acc33 + acc34 + acc35 + acc36 + acc37 + acc38 + acc39 + acc40 +
       acc41 + acc42 + acc43 + acc44 + acc45 + acc46 + acc47 + acc48 + acc49 + acc50 +
       acc51 + acc52 + acc53 + acc54 + acc55 + acc56 + acc57 + acc58 + acc59 + acc60 +
       acc61 + acc62 + acc63 + acc64+bias;


end Behavioral;
