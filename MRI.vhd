library mito;
use work.mito_pkg.all;

entity MRI is
    port (
    mri_in      : in  std_logic_vector(15 downto 0);
    mri_out8    : out std_logic_vector(7 downto 0);  --saida com 8 bit para jump
    mri_out6    : out std_logic_vector(7 downto 0); --saida sempre com 6 bit para branch
    mri_sel     : in  std_logic; -- seletor para saber se vai usar 6 ou 8 bit   
    );
end MRI;

architecture rtl of MRI is
begin   
    process(mri_in, mri_sel)
    begin 
        if mri_sel <= '0' then
            mri_out8 <= mri_in(11 downto 0); -- seletor 0 pega 8 bit
        else mri_sel <= '1' then    
            mri_out6 <= mri_in(7 downto 0); -- seletor 1 pega 6 bit
        end if;
    end process;
end rtl;   