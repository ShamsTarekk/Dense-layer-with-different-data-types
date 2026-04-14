library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.float_pkg.all;
use work.fixed_pkg.all;
use work.fixed_float_types.all;
use work.float_vector_pkg.all;
library std;
use std.textio.all;

entity fp16_tb is
end fp16_tb;

architecture Behavioral of fp16_tb is

    -- Signals for Dense_fp16
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal in_vec    : float16_array(0 to 63);
    signal weights   : float16_2d_array(0 to 63, 0 to 9);
    signal bias      : float16_array(0 to 9);
    signal out_vec   : float16_array(0 to 9);
    signal max_addr  : std_logic_vector(3 downto 0);

    -- File loading control
    signal weight_done : std_logic := '0';
    
    -- Variables for reading files
    signal h_weight_array : integer := 0;

component Dense_fp16 is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        in_vec  : in  float16_array(0 to 63);
        weights : in  float16_2d_array(0 to 63, 0 to 9);
        bias    : in  float16_array(0 to 9);
        out_vec : out float16_array(0 to 9);
        max_addr : out std_logic_vector(3 downto 0)
    );
end component;

begin

    -- Clock generation
    clocking : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    -- Reset process
    reset_proc : process
    begin
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait;
    end process;

    -- Dense_fp16 instantiation
    DUT: Dense_fp16
        port map(
            clk      => clk,
            rst      => rst,
            in_vec   => in_vec,
            weights  => weights,
            bias     => bias,
            out_vec  => out_vec,
            max_addr => max_addr
        );

-- File loading process
load_files : process
    variable line_in, line_in2, line_in3 : line;
    variable bin_str, bin_str2, bin_str3  : string(1 to 16);
    variable slv, slv2, slv3 : std_logic_vector(15 downto 0);
    variable word_idx : integer;
    variable line_words : line;

    file fp16_file       : text open read_mode is "dense_weights_float16_bin.txt";   -- e.g., 10 numbers per line
    file fp16_file_dense : text open read_mode is "dense_biases_float16_bin.txt";    -- 10 lines
    file flatten_output  : text open read_mode is "dense_input_vector_float16_bin.txt"; -- 64 lines
begin
    while (not endfile(fp16_file)) or
          (not endfile(flatten_output)) or
          (not endfile(fp16_file_dense)) loop

        ----------------------------------------------------------------
        -- 1) LOAD WEIGHTS
        ----------------------------------------------------------------
        if not endfile(fp16_file) then
            readline(fp16_file, line_in);
            word_idx := 0;

            -- read all numbers in the line
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
                        <= to_float(slv, 5, 10); -- FP16
                end if;

                word_idx := word_idx + 16;
                h_weight_array <= h_weight_array + 1;
            end loop;
        end if;

        ----------------------------------------------------------------
        -- 2) LOAD FLATTEN INPUT
        ----------------------------------------------------------------
        if (h_weight_array < 64) and (not endfile(flatten_output)) then
            readline(flatten_output, line_in2);
            read(line_in2, bin_str2);

            for j in 1 to 16 loop
                if bin_str2(j) = '1' then
                    slv2(16-j) := '1';
                else
                    slv2(16-j) := '0';
                end if;
            end loop;

            in_vec(h_weight_array) <= to_float(slv2, 5, 10);
        end if;

        ----------------------------------------------------------------
        -- 3) LOAD BIAS
        ----------------------------------------------------------------
        if (h_weight_array < 10) and (not endfile(fp16_file_dense)) then
            readline(fp16_file_dense, line_in3);
            read(line_in3, bin_str3);

            for j in 1 to 16 loop
                if bin_str3(j) = '1' then
                    slv3(16-j) := '1';
                else
                    slv3(16-j) := '0';
                end if;
            end loop;

            bias(h_weight_array) <= to_float(slv3, 5, 10);
        end if;

        wait for 1 ns;
    end loop;

    weight_done <= '1';
    wait;
end process;

end Behavioral;
