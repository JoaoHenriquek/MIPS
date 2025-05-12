entity RBANK is
    port (
        clk         : in std_logic;
        out_sel     : in std_logic_vector(3 downto 0); -- Seleciona quais registradores saem para a ULA
        r0          : in std_logic_vector(15 downto 0);
        r1          : in std_logic_vector(15 downto 0);
        r2          : in std_logic_vector(15 downto 0);
        r3          : in std_logic_vector(15 downto 0);
        rbank_out   : out std_logic_vector(15 downto 0);
        rbank_out1  : out std_logic_vector(15 downto 0);
        rbank_mri   : in std_logic_vector(15 downto 0); -- Entrada do MRI (para branches)
        rbank_sel   : in std_logic; -- 0: Escrita | 1: Leitura
        reg_wr      : in std_logic; -- Sinal de escrita (ativo em '1')
        reg_wr_addr : in std_logic_vector(1 downto 0) -- Endereço do registrador a ser escrito
    );
end RBANK;

architecture rtl of RBANK is 
    type reg_array is array (0 to 3) of std_logic_vector(15 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin 
    -- Processo para escrita (armazena dados nos registradores)
    process(clk)
    begin
        if rising_edge(clk) then
            if rbank_sel = '0' and reg_wr = '1' then
                case reg_wr_addr is
                    when "00"   => regs(0) <= rbank_mri;
                    when "01"   => regs(1) <= rbank_mri;
                    when "10"   => regs(2) <= rbank_mri;
                    when others => regs(3) <= rbank_mri;
                end case;
            end if;
        end if;
    end process;

    -- Processo para leitura (saída para ULA)
    process(clk)
    begin
        if rising_edge(clk) and rbank_sel = '1' then
            case out_sel is
                when "0000" => -- r0 e r0
                    rbank_out  <= regs(0);
                    rbank_out1 <= regs(0);
                when "0001" => -- r0 e r1
                    rbank_out  <= regs(0);
                    rbank_out1 <= regs(1);
                when "0010" => -- r0 e r2
                    rbank_out  <= regs(0);
                    rbank_out1 <= regs(2);
                when "0011" => -- r0 e r3
                    rbank_out  <= regs(0);
                    rbank_out1 <= regs(3);
                when "0100" => -- r1 e r1
                    rbank_out  <= regs(1);
                    rbank_out1 <= regs(1);
                when "0101" => -- r1 e r2
                    rbank_out  <= regs(1);
                    rbank_out1 <= regs(2);
                when "0110" => -- r1 e r3
                    rbank_out  <= regs(1);
                    rbank_out1 <= regs(3);
                when "0111" => -- r2 e r2
                    rbank_out  <= regs(2);
                    rbank_out1 <= regs(2);
                when "1000" => -- r2 e r3
                    rbank_out  <= regs(2);
                    rbank_out1 <= regs(3);
                when "1001" => -- r3 e r3
                    rbank_out  <= regs(3);
                    rbank_out1 <= regs(3);
                when "1010" => -- r0 e MRI (para branch)
                    rbank_out  <= regs(0);
                    rbank_out1 <= rbank_mri;
                when "1011" => -- r1 e MRI
                    rbank_out  <= regs(1);
                    rbank_out1 <= rbank_mri;
                when "1100" => -- r2 e MRI
                    rbank_out  <= regs(2);
                    rbank_out1 <= rbank_mri;
                when "1101" => -- r3 e MRI
                    rbank_out  <= regs(3);
                    rbank_out1 <= rbank_mri;
                when others => -- Caso inválido
                    rbank_out  <= (others => '0');
                    rbank_out1 <= (others => '0');
            end case;
        end if;
    end process;
end rtl;