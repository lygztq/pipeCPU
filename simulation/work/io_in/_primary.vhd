library verilog;
use verilog.vl_types.all;
entity io_in is
    port(
        addr            : in     vl_logic_vector(31 downto 0);
        io_data_out     : out    vl_logic_vector(31 downto 0);
        in_port1        : in     vl_logic_vector(3 downto 0);
        in_port2        : in     vl_logic_vector(3 downto 0);
        dmem_clk        : in     vl_logic
    );
end io_in;
