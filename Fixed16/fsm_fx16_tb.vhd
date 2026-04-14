library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
use work.float_pkg.all;
use work.fixed_pkg.all;
use ieee.std_logic_textio.all;

entity fsm_fx16_tb is
end entity;

architecture sim of fsm_fx16_tb is

    -- Change memory types to 16-bit versions
    signal MEM_inputs : work.my_types.mem_inputs16f := (others => (others => '0'));
    signal MEM_weights : work.my_types.mem_weights16f := (others => (others => '0'));
    signal MEM_biases : work.my_types.mem_biases16f := (others => (others => '0'));

    constant data_width : integer := 16;      -- 16-bit now
    constant addr_width : integer := 640000;
    constant N_INPUTS : integer := 64;
    constant N_NEURONS : integer := 10;
        
    signal out_data  : std_logic_vector(3 downto 0); 
    signal clk : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal start : std_logic := '0';
    signal out_valid : std_logic := '0';
    signal busy : std_logic := '0';

    file my_input_file       : text open read_mode is "flatten_output_10000_images_fixed16_bin.txt";
    file my_weights_file     : text open read_mode is "dense_weights_fixed16_bin_1d.txt";
    file my_biases_file      : text open read_mode is "dense_biases_fixed16_bin_1d.txt";
    file output_file         : text open write_mode is "output_file_fx16.txt";

begin

    DUT: entity work.fsm_dense_fx16
         generic map(
             data_width => data_width,
             N_INPUTS => N_INPUTS,
             N_NEURONS => N_NEURONS
         )
         port map (
             out_data => out_data,
             MEM_INIT_INPUTS => MEM_inputs,
             MEM_INIT_WEIGHTS => MEM_weights,
             MEM_INIT_BIASES => MEM_biases,
             clk => clk,
             rst_n => rst_n,
             start => start,
             out_valid => out_valid,             
             busy => busy
         );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;         

    -- Stimulus: Load memory from files
    stim : process
        variable line_inputs : line;
        variable line_weights : line;
        variable line_biases : line;
        variable i : integer := 0;
        variable w : integer := 0;
        variable b : integer := 0;
        variable tmp_weights : std_logic_vector(15 downto 0); -- 16-bit
        variable tmp_inputs : std_logic_vector(15 downto 0);  -- 16-bit
        variable tmp_biases : std_logic_vector(15 downto 0);  -- 16-bit
    begin

        -- Load weights
        while not endfile(my_weights_file) loop
            readline(my_weights_file, line_weights);
            read(line_weights, tmp_weights);
            MEM_weights(w) <= tmp_weights; 
            w := w + 1;
        end loop;
        report "Loaded " & integer'image(w) & " lines into MEM_WEIGHTS";

        -- Load inputs
        while not endfile(my_input_file) loop
            readline(my_input_file, line_inputs);
            read(line_inputs, tmp_inputs);
            MEM_inputs(i) <= tmp_inputs;
            i := i + 1;            
        end loop;
        report "Loaded " & integer'image(i) & " lines into MEM_INPUTS";

        -- Load biases
        while not endfile(my_biases_file) loop
            readline(my_biases_file, line_biases);
            read(line_biases, tmp_biases);
            MEM_biases(b) <= tmp_biases;
            b := b + 1;          
        end loop;
        report "Loaded " & integer'image(b) & " lines into MEM_BIASES";

        wait;
    end process;

    -- Reset and start FSM
    rst: process
    begin
        rst_n <= '0'; wait for 5 ns;
        rst_n <= '1';
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';        
        wait;
    end process;

    -- Monitor output
    monitor_addr : process(clk)
        variable L : line;
        variable out_bin_str : string(1 to 16); -- 16-bit
        variable i : integer;
        variable image_count : integer := 0;  
    begin
        if rising_edge(clk) then
            if out_valid = '1' then
                for i in 0 to out_data'length-1 loop
                    if out_data(out_data'high - i) = '1' then
                        out_bin_str(i + 1) := '1';
                    else
                        out_bin_str(i + 1) := '0';
                    end if;
                end loop;
                L := new string'(out_bin_str);
                writeline(output_file, L);

                image_count := image_count + 1; 
                if image_count = 10000 then 
                    file_close(output_file); 
                    assert false report "All images processed." severity failure;
                end if;
            end if;
        end if;
    end process;

end architecture;
