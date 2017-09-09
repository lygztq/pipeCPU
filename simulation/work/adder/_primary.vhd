library verilog;
use verilog.vl_types.all;
entity adder is
    port(
        x               : in     vl_logic_vector(31 downto 0);
        y               : out    vl_logic_vector(31 downto 0)
    );
end adder;
