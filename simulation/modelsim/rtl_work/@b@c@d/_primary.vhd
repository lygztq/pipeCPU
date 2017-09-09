library verilog;
use verilog.vl_types.all;
entity BCD is
    port(
        data            : in     vl_logic_vector(4 downto 0);
        hex_high        : out    vl_logic_vector(6 downto 0);
        hex_low         : out    vl_logic_vector(6 downto 0)
    );
end BCD;
