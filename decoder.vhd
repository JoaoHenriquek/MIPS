library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use work.mito_pkg.all;

entity decoder is
    port (
        addr_dest   : in std_logic_vector(5 downto 0);
        decIN       :   in std_logic_vector(15 downto 0);
        ---dec_out_op   :   out std_logic_vector(15 downto 12); ----
        dec_out_rs   :   out std_logic_vector(1 downto 0);
        dec_out_rt   :   out std_logic_vector(1 downto 0);
        dec_out_rd   :   out std_logic_vector(1 downto 0) --saida separa as partes das instruções para entrar no banco de registradores
        decoded_inst: decoded_instruction_type;  ---in
        read_decoder :std_logic
        );
end decoder;

architecture rtl of decoder is
    begin
        process(decIN)
        begin
              if (read_decoder='1') then 
                case(decIN(15 downto 12)) is
                    when "0000"=> 
                    decIn<=I_HALT;
                    when "0001"=>
                    decIn<=I_ADD;
                    when "0010"=>
                    decIn<=I_SUB;
                    when "0011"=>
                    decIn<=I_OR;
                    when "0100"=>
                    decIn<=I_AND;
                    when "0101"=>
                    decIn<=I_BEQ;
                    when "0110"=>
                    decIn<=I_LOAD;
                    when "0111"=>
                    decIn<=I_STORE;
                    when "1000"=>
                    decIn<=I_JUMP;
                    when "1001"=>
                    decIn<=I_MULT;
                end case;
                if (decIN=I_JUMP) then 
                addr_dest <=decIn(11 downto 0);
                else
                dec_out_rd <=decIn(8 downto 7);
                dec_out_rt <=decIn(10 downto 9);
                dec_out_rs <=decIn(12 downto 11);
                addr_dest  <=decIn(5 downto 0);

                end if;
        end process;
    end rtl;