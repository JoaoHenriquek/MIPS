library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use work.mito_pkg.all;

entity mux_mem is
    Port (
        m_in0   : in std_logic_vector(15 downto 0);
        m_in1   : in std_logic_vector(15 downto 0);
        mux_sel : in std_logic;
        mux_out : out std_logic_vector(15 downto 0)   
    );
end mux_mem;

architecture rtl of mux_mem is
begin
    process(mux_sel)
    begin
        if mux_sel <= '0' then
            mux_out <= m_in0;
    else 
            mux_out <= m_in1;
    end if;
end process;
end rtl;
