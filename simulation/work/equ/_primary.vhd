library verilog;
use verilog.vl_types.all;
entity equ is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        is_equ          : out    vl_logic
    );
end equ;
