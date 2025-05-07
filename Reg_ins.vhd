entity Reg_ins is
    port (
        ri_in       :   in std_logic_vector(15 downto 0);
        ri_out_op   :   out std_logic_vector(15 downto 12); 
        ri_out_rs   :   out std_logic_vector(11 downto 10);
        ri_out_rt   :   out std_logic_vector(9 downto 8);
        ri_out_rd   :   out std_logic_vector(7 downto 6); --saida separa as partes das instruções para entrar no banco de registradores
        ri_sel      :   in std_logic;                     --nao tenho certeza se vai ser usado mas ja deixei pronto
    );
end Reg_ins;

architecture rtl of Reg_ins is
    begin
        process(ri_in)
        begin
            ri_out_op <= ri_in(15 downto 12);  -- opcode
            ri_out_rs <= ri_in(11 downto 10);  -- registrador fonte
            ri_out_rt <= ri_in(9 downto 8);    -- registrador intermediário
            ri_out_rd <= ri_in(7 downto 6);    -- registrador destino
        end process;
    end rtl;