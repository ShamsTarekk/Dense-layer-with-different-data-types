library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;
use work.float_VECTOR_pkg.all;
use work.fixed_VECTOR_pkg.all;
use work.my_types.all;

entity fsm_dense_fx8 is
generic(
data_width: integer := 8;
N_INPUTS   : integer := 64;
N_NEURONS  : integer := 10
);
    port(

        MEM_INIT_INPUTS : in work.my_types.mem_inputs8;
        MEM_INIT_WEIGHTS : in work.my_types.mem_weights8;
        MEM_INIT_BIASES : in work.my_types.mem_biases8;
        clk       : in  std_logic;
		rst_n     : in  std_logic;
		start     : in  std_logic;
		out_valid : out std_logic;
		out_data  : out std_logic_vector(3 downto 0);
		busy      : out std_logic

    );
end FSM_DENSE_fx8;

architecture behavior of fsm_dense_fx8 is

    type state_type is ( 
        S_IDLE,
        S_LOAD_FILES,
        S_MULTIPLY,
        S_ACCUMULATE,
        S_MAX_SELECT,
        S_DONE
    );

    type mo  is array (0 to 9, 0 to 63) of fixed8;
    type mi1 is array (0 to 63) of fixed8;
    type bi  is array (0 to 9)  of fixed8;

    signal state : state_type := S_IDLE;

    signal input_buf  : mi1;
    signal weight_buf : mo;
    signal bias_buf   : bi;
    signal mult_output_r : mo;
    signal acc_output    : bi;

    signal addressing : std_logic_vector(3 downto 0) := (others => '0');

    signal out_valid_r : std_logic := '0';
    signal busy_r      : std_logic := '0';
    signal out_data_r  : std_logic_vector(3 downto 0) := (others => '0');


component Accumulatorfixed8 is
    Port (
        acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8,
        acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16,
        acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24,
        acc25, acc26, acc27, acc28, acc29, acc30, acc31, acc32,
        acc33, acc34, acc35, acc36, acc37, acc38, acc39, acc40,
        acc41, acc42, acc43, acc44, acc45, acc46, acc47, acc48,
        acc49, acc50, acc51, acc52, acc53, acc54, acc55, acc56,
        acc57, acc58, acc59, acc60, acc61, acc62, acc63, acc64,
        bias : in fixed8;
        res  : out fixed8
        
    );
end component;

component Multfixed8 is
    Port (
        op1, op2 : in fixed8;
        res      : out fixed8
    );
end component;

component getting_Address_of_maxfixed8 is
    Port (
        clk : in std_logic;
        act1,act2,act3,act4,act5,
        act6,act7,act8,act9,act10 : in fixed8;
        address : out std_logic_vector(3 downto 0)
    );
end component;
begin
gen_mult: for y in 0 to 9 generate
    gen_mult_in_group: for i in 0 to 63 generate
        mult_inst: Multfixed8
            port map(
                op1 => weight_buf(y,i),
                op2 => input_buf(i),
                res => mult_output_r(y,i)
            );
    end generate;
end generate;

  gen_acc: for k in 0 to 9 generate
        acc_inst: Accumulatorfixed8
            port map (
                acc1  => mult_output_r(k,0),  acc2 => mult_output_r(k,1),
                acc3  => mult_output_r(k,2),  acc4 => mult_output_r(k,3),
                acc5  => mult_output_r(k,4),  acc6 => mult_output_r(k,5),
                acc7  => mult_output_r(k,6),  acc8 => mult_output_r(k,7),
                acc9  => mult_output_r(k,8),  acc10 => mult_output_r(k,9),
                acc11 => mult_output_r(k,10), acc12 => mult_output_r(k,11),
                acc13 => mult_output_r(k,12), acc14 => mult_output_r(k,13),
                acc15 => mult_output_r(k,14), acc16 => mult_output_r(k,15),
                acc17 => mult_output_r(k,16), acc18 => mult_output_r(k,17),
                acc19 => mult_output_r(k,18), acc20 => mult_output_r(k,19),
                acc21 => mult_output_r(k,20), acc22 => mult_output_r(k,21),
                acc23 => mult_output_r(k,22), acc24 => mult_output_r(k,23),
                acc25 => mult_output_r(k,24), acc26 => mult_output_r(k,25),
                acc27 => mult_output_r(k,26), acc28 => mult_output_r(k,27),
                acc29 => mult_output_r(k,28), acc30 => mult_output_r(k,29),
                acc31 => mult_output_r(k,30), acc32 => mult_output_r(k,31),
                acc33 => mult_output_r(k,32), acc34 => mult_output_r(k,33),
                acc35 => mult_output_r(k,34), acc36 => mult_output_r(k,35),
                acc37 => mult_output_r(k,36), acc38 => mult_output_r(k,37),
                acc39 => mult_output_r(k,38), acc40 => mult_output_r(k,39),
                acc41 => mult_output_r(k,40), acc42 => mult_output_r(k,41),
                acc43 => mult_output_r(k,42), acc44 => mult_output_r(k,43),
                acc45 => mult_output_r(k,44), acc46 => mult_output_r(k,45),
                acc47 => mult_output_r(k,46), acc48 => mult_output_r(k,47),
                acc49 => mult_output_r(k,48), acc50 => mult_output_r(k,49),
                acc51 => mult_output_r(k,50), acc52 => mult_output_r(k,51),
                acc53 => mult_output_r(k,52), acc54 => mult_output_r(k,53),
                acc55 => mult_output_r(k,54), acc56 => mult_output_r(k,55),
                acc57 => mult_output_r(k,56), acc58 => mult_output_r(k,57),
                acc59 => mult_output_r(k,58), acc60 => mult_output_r(k,59),
                acc61 => mult_output_r(k,60), acc62 => mult_output_r(k,61),
                acc63 => mult_output_r(k,62), acc64 => mult_output_r(k,63),
                bias => bias_buf(k),
                res  => acc_output(k)
            );
    end generate;
add_req: getting_Address_of_maxfixed8
        port map(
            clk => clk,
            act1 => acc_output(0),
            act2 => acc_output(1),
            act3 => acc_output(2),
            act4 => acc_output(3),
            act5 => acc_output(4),
            act6 => acc_output(5),
            act7 => acc_output(6),
            act8 => acc_output(7),
            act9 => acc_output(8),
            act10 => acc_output(9),
            address => addressing
        );
process(clk, rst_n)
            variable v_image_idx : integer range 0 to 9999 := 0;
        begin
            if rst_n = '0' then
                state <= S_IDLE;
                out_valid_r <= '0';
                busy_r <= '0';
                out_data_r <= (others => '0');
                v_image_idx := 0;
        
            elsif rising_edge(clk) then
                busy_r <= '1';
                out_valid_r <= '0';
        
                case state is
                    when S_IDLE =>
                        busy_r <= '0';
                        if start = '1' then
                            state <= S_LOAD_FILES;
                        end if;
        
                    when S_LOAD_FILES =>
                        for y in 0 to 9 loop
                            for i in 0 to 63 loop
                               weight_buf(y,i) <= fixed8(MEM_INIT_WEIGHTS(y*10 + i));
                            end loop;
                        end loop;
        
                        for i in 0 to 63 loop
                            input_buf(i) <=fixed8(MEM_INIT_INPUTS(v_image_idx*64 + i));
                        end loop;
        
                        for k in 0 to 9 loop
                            bias_buf(k) <=fixed8(MEM_INIT_BIASES(k));
                        end loop;
        
                        state <= S_MULTIPLY;
        
                    when S_MULTIPLY =>
                        state <= S_ACCUMULATE;
        
                    when S_ACCUMULATE =>
                        state <= S_MAX_SELECT;
        
                    when S_MAX_SELECT =>
                        state <= S_DONE;
        
                    when S_DONE =>
                        out_valid_r <= '1';
                        busy_r <= '0';
                        out_data_r <= addressing;
        
                        if v_image_idx < 9999 then
                            v_image_idx := v_image_idx + 1;
                            state <= S_LOAD_FILES;
                        else
                            v_image_idx := 0;
                            state <= S_IDLE;
                        end if;
        
                end case;
            end if;
        end process;
        
        out_valid <= out_valid_r;
        busy      <= busy_r;
        out_data  <= out_data_r;
end behavior;