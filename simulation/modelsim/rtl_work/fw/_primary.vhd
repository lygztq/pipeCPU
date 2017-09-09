library verilog;
use verilog.vl_types.all;
entity fw is
    port(
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        fwda            : out    vl_logic_vector(1 downto 0);
        fwdb            : out    vl_logic_vector(1 downto 0);
        ewreg           : in     vl_logic;
        ern             : in     vl_logic_vector(4 downto 0);
        mwreg           : in     vl_logic;
        mrn             : in     vl_logic_vector(4 downto 0);
        em2reg          : in     vl_logic;
        mm2reg          : in     vl_logic;
        wpcir           : out    vl_logic;
        clock           : in     vl_logic
    );
end fw;
