library verilog;
use verilog.vl_types.all;
entity pipelined_computer is
    port(
        resetn          : in     vl_logic;
        clock           : in     vl_logic;
        mem_clock       : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0);
        inst            : out    vl_logic_vector(31 downto 0);
        ealu            : out    vl_logic_vector(31 downto 0);
        malu            : out    vl_logic_vector(31 downto 0);
        walu            : out    vl_logic_vector(31 downto 0);
        input_port1     : in     vl_logic_vector(3 downto 0);
        input_port2     : in     vl_logic_vector(3 downto 0);
        output_port     : out    vl_logic_vector(4 downto 0)
    );
end pipelined_computer;
