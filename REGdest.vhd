library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGdest is
    Port (
        m_in0   : in std_logic_vector(15 downto 0);
        m_in1   : in std_logic_vector(15 downto 0);
        mux_sel : in std_logic;
        mux_out : out std_logic_vector(15 downto 0)   
    );
end REGdest;

architecture rtl of REGdest is
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