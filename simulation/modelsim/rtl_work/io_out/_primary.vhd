library verilog;
use verilog.vl_types.all;
entity io_out is
    port(
        addr            : in     vl_logic_vector(31 downto 0);
        out_port_write_enable: in     vl_logic;
        dmem_clk        : in     vl_logic;
        data_in         : in     vl_logic_vector(31 downto 0);
        out_port        : out    vl_logic_vector(4 downto 0)
    );
end io_out;
