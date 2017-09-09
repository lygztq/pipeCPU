library verilog;
use verilog.vl_types.all;
entity pipemem is
    port(
        mwmem           : in     vl_logic;
        address         : in     vl_logic_vector(31 downto 0);
        datain          : in     vl_logic_vector(31 downto 0);
        clock           : in     vl_logic;
        ram_clock       : in     vl_logic;
        mmo             : out    vl_logic_vector(31 downto 0);
        input_port1     : in     vl_logic_vector(3 downto 0);
        input_port2     : in     vl_logic_vector(3 downto 0);
        output_port     : out    vl_logic_vector(4 downto 0)
    );
end pipemem;
