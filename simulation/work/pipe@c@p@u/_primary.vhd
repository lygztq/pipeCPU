library verilog;
use verilog.vl_types.all;
entity pipeCPU is
    port(
        clock           : in     vl_logic;
        resetn          : in     vl_logic;
        op1             : in     vl_logic_vector(3 downto 0);
        op2             : in     vl_logic_vector(3 downto 0);
        inputLight      : out    vl_logic_vector(7 downto 0);
        outputLight     : out    vl_logic_vector(4 downto 0);
        testlight       : out    vl_logic;
        hex1            : out    vl_logic_vector(6 downto 0);
        hex2            : out    vl_logic_vector(6 downto 0);
        hex3            : out    vl_logic_vector(6 downto 0);
        hex4            : out    vl_logic_vector(6 downto 0);
        hex5            : out    vl_logic_vector(6 downto 0);
        hex6            : out    vl_logic_vector(6 downto 0);
        hex7            : out    vl_logic_vector(6 downto 0);
        hex8            : out    vl_logic_vector(6 downto 0)
    );
end pipeCPU;
