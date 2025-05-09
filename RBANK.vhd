entity RBANK is
    port (
        clk         : in std_logic;
        out_sel     : in std_logic_vector(3 downto 0); -- determina quais registradores vão sair para a ula EX: 00 sai r1 e r3
        r0          : in std_logic_vector(15 downto 0);
        r1          : in std_logic_vector(15 downto 0);
        r2          : in std_logic_vector(15 downto 0);
        r3          : in std_logic_vector(15 downto 0);
        rbank_out   : out std_logic_vector(15 downto 0);
        rbank_out1  : out std_logic_vector(15 downto 0);
        rbank_mri   : in std_logic_vector(15 downto 0); -- entrada do que sair do mri // tem q aumentar os registradores pra enfiar isso em algum lugar
        rbank_sel   : in std_logic; --0 so entra / 1 so sai
         
    );
end RBANK;

architecture rtl of RBANK is 
    type reg_array is array (0 to 3) of std_logic_vector(15 downto 0); -- define um tipo de dado(reg_array), representa os 4 reg de 16 bit
    signal regs : reg_array := (others => (others => '0')); --Declara o sinl de armazenamento e inicializa todos os bits de todos os registradores com 0
begin 
    process(clk,rbank_out,rbank_out1,rbank_sel,rbank_mri)
    begin
        if rising_edge(clk) and rbank_sel = '1' then
            case out_sel is
                when "0000" =>
                    rbank_out  <= r0;
                    rbank_out1 <= r0;
                when "0001" =>
                    rbank_out  <= r0;
                    rbank_out1 <= r1;
                when "0010" =>
                    rbank_out  <= r0;
                    rbank_out1 <= r2;
                when "0011" =>
                    rbank_out  <= r0;
                    rbank_out1 <= r3;
                when "0100" =>
                    rbank_out  <= r1;
                    rbank_out1 <= r1;
                when "0101" =>
                    rbank_out  <= r1;
                    rbank_out1 <= r2;
                when "0110" =>
                    rbank_out  <= r1;
                    rbank_out1 <= r3;
                when "0111" =>
                    rbank_out  <= r2;
                    rbank_out1 <= r2;
                when "1000" =>
                    rbank_out  <= r2;
                    rbank_out1 <= r3;
                when "1001" =>
                    rbank_out  <= r3;
                    rbank_out1 <= r3;
                when "1010" => -----------------MRI sai para o registrador B para casos de branch
                    rbank_out  <= r0; -- acho que da para fazer um jump com soma com o hardware EX: jump r3 + 25
                    rbank_out1 <= rbank_mri;
                when "1011" =>
                    rbank_out  <= r1;
                    rbank_out1 <= rbank_mri;
                when "1010" =>
                    rbank_out  <= r2;
                    rbank_out1 <= rbank_mri;
                when "1011" =>
                    rbank_out  <= r3;
                    rbank_out1 <= rbank_mri;
                when others =>
                    rbank_out  <= (others => '0');
                    rbank_out1 <= (others => '0');
            end case;
        end if;
        if rising_edge(clk) and rbank_sel = '0' then -- FAZER