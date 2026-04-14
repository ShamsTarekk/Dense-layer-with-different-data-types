
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.float_pkg.all;
use work.fixed_float_types.all;
entity Accumulatorfp64 is
  Port (acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16, acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24, acc25, acc26, acc27, acc28, acc29, acc30, acc31, acc32, acc33, acc34, acc35, acc36, acc37, acc38, acc39, acc40, acc41, acc42, acc43, acc44, acc45, acc46, acc47, acc48, acc49, acc50, acc51, acc52, acc53, acc54, acc55, acc56, acc57, acc58, acc59, acc60, acc61, acc62, acc63, acc64,bias:in float64;
        res:out float64);
end Accumulatorfp64;

architecture Behavioral of Accumulatorfp64 is
signal first_stage1, first_stage2, first_stage3, first_stage4, first_stage5, first_stage6, first_stage7, first_stage8, first_stage9, first_stage10, first_stage11, first_stage12, first_stage13, first_stage14, first_stage15, first_stage16, first_stage17, first_stage18, first_stage19, first_stage20, first_stage21, first_stage22, first_stage23, first_stage24, first_stage25, first_stage26, first_stage27, first_stage28, first_stage29, first_stage30, first_stage31, first_stage32, second_stage1, second_stage2, second_stage3, second_stage4, second_stage5, second_stage6, second_stage7, second_stage8, second_stage9, second_stage10, second_stage11, second_stage12, second_stage13, second_stage14, second_stage15, second_stage16, third_stage1, third_stage2, third_stage3, third_stage4, third_stage5, third_stage6, third_stage7, third_stage8, fourth_stage1, fourth_stage2, fourth_stage3, fourth_stage4, fifth_stage1, fifth_stage2, sixth_stage1:float64;


begin
--------------------------------------------------------------------
-- Stage 1: 64 ? 32
--------------------------------------------------------------------
first_stage1  <= acc1  + acc2;
first_stage2  <= acc3  + acc4;
first_stage3  <= acc5  + acc6;
first_stage4  <= acc7  + acc8;
first_stage5  <= acc9  + acc10;
first_stage6  <= acc11 + acc12;
first_stage7  <= acc13 + acc14;
first_stage8  <= acc15 + acc16;
first_stage9  <= acc17 + acc18;
first_stage10 <= acc19 + acc20;
first_stage11 <= acc21 + acc22;
first_stage12 <= acc23 + acc24;
first_stage13 <= acc25 + acc26;
first_stage14 <= acc27 + acc28;
first_stage15 <= acc29 + acc30;
first_stage16 <= acc31 + acc32;
first_stage17 <= acc33 + acc34;
first_stage18 <= acc35 + acc36;
first_stage19 <= acc37 + acc38;
first_stage20 <= acc39 + acc40;
first_stage21 <= acc41 + acc42;
first_stage22 <= acc43 + acc44;
first_stage23 <= acc45 + acc46;
first_stage24 <= acc47 + acc48;
first_stage25 <= acc49 + acc50;
first_stage26 <= acc51 + acc52;
first_stage27 <= acc53 + acc54;
first_stage28 <= acc55 + acc56;
first_stage29 <= acc57 + acc58;
first_stage30 <= acc59 + acc60;
first_stage31 <= acc61 + acc62;
first_stage32 <= acc63 + acc64;

--------------------------------------------------------------------
-- Stage 2: 32 ? 16
--------------------------------------------------------------------
second_stage1  <= first_stage1  + first_stage2;
second_stage2  <= first_stage3  + first_stage4;
second_stage3  <= first_stage5  + first_stage6;
second_stage4  <= first_stage7  + first_stage8;
second_stage5  <= first_stage9  + first_stage10;
second_stage6  <= first_stage11 + first_stage12;
second_stage7  <= first_stage13 + first_stage14;
second_stage8  <= first_stage15 + first_stage16;
second_stage9  <= first_stage17 + first_stage18;
second_stage10 <= first_stage19 + first_stage20;
second_stage11 <= first_stage21 + first_stage22;
second_stage12 <= first_stage23 + first_stage24;
second_stage13 <= first_stage25 + first_stage26;
second_stage14 <= first_stage27 + first_stage28;
second_stage15 <= first_stage29 + first_stage30;
second_stage16 <= first_stage31 + first_stage32;

--------------------------------------------------------------------
-- Stage 3: 16 ? 8
--------------------------------------------------------------------
third_stage1 <= second_stage1  + second_stage2;
third_stage2 <= second_stage3  + second_stage4;
third_stage3 <= second_stage5  + second_stage6;
third_stage4 <= second_stage7  + second_stage8;
third_stage5 <= second_stage9  + second_stage10;
third_stage6 <= second_stage11 + second_stage12;
third_stage7 <= second_stage13 + second_stage14;
third_stage8 <= second_stage15 + second_stage16;

--------------------------------------------------------------------
-- Stage 4: 8 ? 4
--------------------------------------------------------------------
fourth_stage1 <= third_stage1 + third_stage2;
fourth_stage2 <= third_stage3 + third_stage4;
fourth_stage3 <= third_stage5 + third_stage6;
fourth_stage4 <= third_stage7 + third_stage8;

--------------------------------------------------------------------
-- Stage 5: 4 ? 2
--------------------------------------------------------------------
fifth_stage1 <= fourth_stage1 + fourth_stage2;
fifth_stage2 <= fourth_stage3 + fourth_stage4;

--------------------------------------------------------------------
-- Stage 6: 2 ? 1
--------------------------------------------------------------------
sixth_stage1 <= fifth_stage1 + fifth_stage2;

--------------------------------------------------------------------
-- Final Result
--------------------------------------------------------------------
res <= sixth_stage1 + bias;


end Behavioral;
