-- dense_layer_fixed16
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.fixed_pkg.all;
use work.fixed_float_types.all;
use work.fixed_vector_pkg.all;
use std.textio.all;

entity fixed16_tb is
end fixed16_tb;

architecture Behavioral of fixed16_tb is

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    subtype fixed16 is sfixed(0 downto -15);

    signal in_vec  : fixed16_array(0 to 63) ;
    signal weights : fixed16_2d_array(0 to 63, 0 to 9);
    signal bias    : fixed16_array(0 to 9);
    signal out_vec : fixed16_array(0 to 9);
    signal max_addr: std_logic_vector(3 downto 0);
    signal max_snapshot : std_logic_vector(3 downto 0); 


    signal h_weight_array : integer := 0;
    signal weight_done    : std_logic := '0';

    component Dense_fixed16 is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            in_vec   : in  fixed16_array(0 to 63);
            weights  : in  fixed16_2d_array(0 to 63, 0 to 9);
            bias     : in  fixed16_array(0 to 9);
            out_vec  : out fixed16_array(0 to 9);
            max_addr : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    --------------------------------------------------------------------
    -- CLOCK GENERATION
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 1 ns;
            clk <= '1'; wait for 1 ns;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- RESET
    --------------------------------------------------------------------
    rst_process : process
    begin
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        wait;
    end process;

    --------------------------------------------------------------------
    -- Dense_fixed8 INSTANCE
    ------------------------------------------------------------------
    DUT: Dense_fixed16
        port map(
            clk      => clk,
            rst      => rst,
            in_vec   => in_vec,
            weights  => weights,
            bias     => bias,
            out_vec  => out_vec,
            max_addr => max_addr
        );
        capture_max : process(clk)
        begin
            if rising_edge(clk) then
                if h_weight_array = 640 then  
                    max_snapshot <= max_addr;
                end if;
            end if;
        end process;
    --------------------------------------------------------------------
    -- FILE LOADING PROCESS
    --------------------------------------------------------------------
    load_files : process
        variable line_in, line_in2, line_in3 : line;
        variable bin_str, bin_str2, bin_str3  : string(1 to 16);
        variable slv, slv2, slv3 : std_logic_vector(15 downto 0);
        variable word_idx : integer;
        variable line_words : line;
    
        file fweight       : text open read_mode is "dense_weights_fixed16_bin_1d.txt";  
        file fbias         : text open read_mode is "dense_biases_fixed16_bin_1d.txt";    
        file fin_flatten   : text open read_mode is "dense_input_vector_fixed16_bin.txt"; 
    
    begin 
    
            for i in 0 to 63 loop
                in_vec(i) <= to_sfixed(0.0, 0, -15);
                for j in 0 to 9 loop
                    weights(i,j) <= to_sfixed(0.0, 0, -15);
                end loop;
            end loop;
        
        while (not endfile(fweight)) or
              (not endfile(fin_flatten)) or
              (not endfile(fbias)) loop

            if not endfile(fweight) then
                readline(fweight, line_in);
                word_idx := 0;
                while line_in'length - word_idx >= 16 loop
                    for j in 1 to 16 loop
                        bin_str(j) := line_in(j + word_idx);
                    end loop;
                    for j in 1 to 16 loop
                        if bin_str(j) = '1' then
                            slv(16-j) := '1';
                        else
                            slv(16-j) := '0';
                        end if;
                    end loop;
                    if h_weight_array <= 639 then
                        weights(h_weight_array mod 64, h_weight_array / 64)
                            <= to_sfixed(slv, 0, -15);
                    end if;
                    word_idx := word_idx + 16;
                    h_weight_array <= h_weight_array + 1;
                end loop;
            end if;

            if (h_weight_array < 64) and (not endfile(fin_flatten)) then
                readline(fin_flatten, line_in2);
                read(line_in2, bin_str2);
                for j in 1 to 16 loop
                    if bin_str2(j) = '1' then
                        slv2(16-j) := '1';
                    else
                        slv2(16-j) := '0';
                    end if;
                end loop;
                in_vec(h_weight_array) <= to_sfixed(slv2, 0, -15);
            end if;

            if (h_weight_array < 10) and (not endfile(fbias)) then
                readline(fbias, line_in3);
                read(line_in3, bin_str3);
                for j in 1 to 16 loop
                    if bin_str3(j) = '1' then
                        slv3(16-j) := '1';
                    else
                        slv3(16-j) := '0';
                    end if;
                end loop;
                bias(h_weight_array) <= to_sfixed(slv3, 0, -15);
            end if;

            wait for 1 ns;
        end loop;

        weight_done <= '1';
        wait;
    end process;

end Behavioral;
