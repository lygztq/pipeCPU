library verilog;
use verilog.vl_types.all;
entity bubble is
    port(
        wpcir           : in     vl_logic;
        mid_dwreg       : in     vl_logic;
        mid_dm2reg      : in     vl_logic;
        mid_dwmem       : in     vl_logic;
        mid_pcsource    : in     vl_logic_vector(1 downto 0);
        dwreg           : out    vl_logic;
        dm2reg          : out    vl_logic;
        dwmem           : out    vl_logic;
        pcsource        : out    vl_logic_vector(1 downto 0)
    );
end bubble;
