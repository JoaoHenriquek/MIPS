library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use work.mito_pkg.all;

entity ula_in1 is
    Port (
        m_in0   : in std_logic_vector(15 downto 0);
        m_in1   : in std_logic_vector(15 downto 0);
        m_in2   : in std_logic_vector(15 downto 0);
        mux_sel : in std_logic_vector(2 downto 0);
        mux_out : out std_logic_vector(15 downto 0)   
    );
end ula_in1;

architecture rtl of ula_in1 is
begin
    process(mux_sel)
    begin
        if mux_sel <= "00" then
            mux_out <= m_in0;
        elsif mux_sel <= "01" then 
            mux_out <= m_in1;
        elsif mux_sel <= "11" then
            mux_out <= m_in2;
       
    end if;
end process;
end rtl;