library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;

entity getting_Address_of_maxfixed16 is
  Port (
    clk    : in  std_logic;
    act1   : in  sfixed(3 downto -12);
    act2   : in  sfixed(3 downto -12);
    act3   : in  sfixed(3 downto -12);
    act4   : in  sfixed(3 downto -12);
    act5   : in  sfixed(3 downto -12);
    act6   : in  sfixed(3 downto -12);
    act7   : in  sfixed(3 downto -12);
    act8   : in  sfixed(3 downto -12);
    act9   : in  sfixed(3 downto -12);
    act10  : in  sfixed(3 downto -12);
    address : out std_logic_vector(3 downto 0)
  );
end getting_Address_of_maxfixed16;

architecture Behavioral of getting_Address_of_maxfixed16 is
begin
process(clk)
begin
    if rising_edge(clk) then
        if (act1>act2 and act1>act3 and act1>act4 and act1>act5 and act1>act6 and act1>act7 and act1>act8 and act1>act9 and act1>act10) then
            address <= "0000";
        elsif (act2>act1 and act2>act3 and act2>act4 and act2>act5 and act2>act6 and act2>act7 and act2>act8 and act2>act9 and act2>act10) then
            address <= "0001";
        elsif (act3>act1 and act3>act2 and act3>act4 and act3>act5 and act3>act6 and act3>act7 and act3>act8 and act3>act9 and act3>act10) then
            address <= "0010";
        elsif (act4>act1 and act4>act2 and act4>act3 and act4>act5 and act4>act6 and act4>act7 and act4>act8 and act4>act9 and act4>act10) then
            address <= "0011";
        elsif (act5>act1 and act5>act2 and act5>act3 and act5>act4 and act5>act6 and act5>act7 and act5>act8 and act5>act9 and act5>act10) then
            address <= "0100";
        elsif (act6>act1 and act6>act2 and act6>act3 and act6>act4 and act6>act5 and act6>act7 and act6>act8 and act6>act9 and act6>act10) then
            address <= "0101";
        elsif (act7>act1 and act7>act2 and act7>act3 and act7>act4 and act7>act5 and act7>act6 and act7>act8 and act7>act9 and act7>act10) then
            address <= "0110";
        elsif (act8>act1 and act8>act2 and act8>act3 and act8>act4 and act8>act5 and act8>act6 and act8>act7 and act8>act9 and act8>act10) then
            address <= "0111";
        elsif (act9>act1 and act9>act2 and act9>act3 and act9>act4 and act9>act5 and act9>act6 and act9>act7 and act9>act8 and act9>act10) then
            address <= "1000";
        elsif (act10>act1 and act10>act2 and act10>act3 and act10>act4 and act10>act5 and act10>act6 and act10>act7 and act10>act8 and act10>act9) then
            address <= "1001";
        end if;
    end if;
end process;

end Behavioral;
