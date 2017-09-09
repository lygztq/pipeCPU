library verilog;
use verilog.vl_types.all;
entity divide_inst is
    port(
        inst            : in     vl_logic_vector(31 downto 0);
        rs              : out    vl_logic_vector(4 downto 0);
        rt              : out    vl_logic_vector(4 downto 0);
        rd              : out    vl_logic_vector(4 downto 0);
        op              : out    vl_logic_vector(5 downto 0);
        func            : out    vl_logic_vector(5 downto 0)
    );
end divide_inst;
