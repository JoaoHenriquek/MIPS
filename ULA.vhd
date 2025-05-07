entity ULA is
    port (
        ula_in : in std_logic_vector(15 downto 0);
        ula_in1: in std_logic_vector(15 downto 0);
        ula_sel: in std_logic_vector(3 downto 0);
        ula_out: out std_logic_vector(16 downto 0);
    );
end ULA;

architecture rtl of ULA is
    begin
        process(ula_in, ula_in1, ula_sel)
            variable A_int : signed(15 downto 0); -- ula_in
            variable B_int : signed(15 downto 0); -- ula_in1
            variable R    : signed(15 downto 0);  -- ula_out(resultado da operação)
        begin
            A_int := signed(ula_in); -- recebe as entradas da ula com sinal
            B_int := signed(ula_in1);
    
            case ula_sel is
                when "0000" =>---------------------- ADD
                    R := A_int + B_int;
                when "0001" =>---------------------- SUB
                    R := A_int - B_int;
                when "0010" =>---------------------- AND
                    R := A_int and B_int;
                when "0011" =>---------------------- OR
                    R := A_int or B_int;
                when others =>
                    R := (others => '0');  -- Resultado padrão (zero)
            end case;
    
            ula_out <= std_logic_vector(R);
        end process;
    end rtl;