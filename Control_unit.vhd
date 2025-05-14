end controlUnit;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library mito;
use work.mito_pkg.all;

entity control_unit is
    Port (
        clk         : in  STD_LOGIC;               -- Clock
        reset       : in  STD_LOGIC;               -- Reset
        opcode      : in  STD_LOGIC_VECTOR(3 downto 0);  -- Opcode (4 bits)
        -- Sinais de controle para o datapath/caminho de dados/parte operativa:
        
        RegDst      : out STD_LOGIC;               -- Seleção do registrador destino
        RegWrite    : out STD_LOGIC;               -- Habilita escrita no banco de registradores
        ---ula---
        UlaIN1     : out STD_LOGIC;               -- Seleção da entrada A da ULA
        ulaIN2     : out STD_LOGIC_VECTOR(1 downto 0); -- Seleção da entrada B da ULA
        ALUOp       : out STD_LOGIC_VECTOR(2 downto 0); -- Operação da ULA (add, sub, and, or)
        --MEMORIA 
        MemRead     : out STD_LOGIC;               -- Habilita leitura da memória
        MemWrite    : out STD_LOGIC;               -- Habilita escrita na memória
        MemtoReg    : out STD_LOGIC;               -- Seleção do dado para write-back //MDR--->registrador
        MEnsel      : OUT STD_LOGIC;              --seletor entre ula_out e pc pra entrar no memoria 
        

        ImmExt      : out STD_LOGIC                -- Controle de extensão de sinal
        PCWrite     : out STD_LOGIC;               -- Habilita atualização do PC
        PCSource    : out STD_LOGIC_VECTOR(1 downto 0) -- Fonte do próximo PC ---MuxPC 
        en_flag     : out std_logic;
        Halt        : out std_logic;

    );
end control_unit;

architecture Behavioral of control_unit is
    -- Estados da FSM:
    type State_Type is (
        FETCH,      -- Busca da instrução
        DECODE,     -- Decodificação
        EXECUTE,    -- Execução (ULA)
        MEM,        -- Acesso à memória (load/store)
        WRITE_BACK, -- Write-back (registradores)
        BRANCH,     -- Branch (BEQ)
        JUMP        -- Jump incondicional
    );
    
    signal current_state, next_state : State_Type;
    
    -- Opcodes das instruções (exemplo:
    constant OP_ADD   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant OP_SUB   : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant OP_AND   : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant OP_OR    : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant OP_BEQ   : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant OP_JUMP  : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant OP_LOAD  : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    constant OP_STORE : STD_LOGIC_VECTOR(3 downto 0) := "0111";
    constant OP_MULTI : STD_LOGIC_VECTOR(3 downto 0) := "1000";

begin
    -- Transição de estados
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= FETCH;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Lógica de próximo estado e saídas
    process(current_state, opcode)
    begin
        -- Valores padrão (evitar latches)
        RegDst    <= '0'; 
        RegWrite  <= '0';
        RegRead   <= '0';
        UlaIN1    <= '0';
        ulaIN2    <= "00";
        ALUOp     <= "000";
        en_flag   <= "0";
        MemRead   <= '0';
        MemWrite  <= '0';
        MemtoReg  <= '0';
        MEnsel    <= '0';
        PCWrite   <= '0';
        PCSource  <= "00";
        ImmExt    <= '0';
        Halt      <= "0";



        next_state <= FETCH;

        case current_state is
            -- Estado FETCH: Busca da instrução
            when FETCH =>
                MemRead <= '1';         -- Lê memória de instruções
                PCWrite <= '1';          -- Atualiza PC (PC + 1)
                next_state <= DECODE;

            -- Estado DECODE (ATIVO): Lê registradores e estende imediato
            when DECODE =>
                RegRead <= '1';          -- Habilita leitura de rs e rt
                ImmExt  <= '1';          -- Estende sinal do imediato (para BEQ/LOAD/STORE)
                next_state <= EXECUTE;

            -- Estado EXECUTE: Execução da operação
            when EXECUTE =>
                case opcode is
                    when OP_ADD | OP_SUB | OP_AND | OP_OR =>  -- Instruções aritméticas
                        UlaIN1 <= '1';              -- Entrada A: registrador rs
                        ulaIN2 <= "00";             -- Entrada B: registrador rt
                        ALUOp   <= opcode(2 downto 0); -- Define operação (ex: 000=ADD)
                        next_state <= WRITE_BACK;

                    when OP_BEQ =>                   -- Branch if equal
                        UlaIN1 <= '1';              -- Compara rs e rt
                        ulaIN2 <= "00";             -- Entrada B: registrador rt
                        ALUOp   <= "001";            -- Subtração (para verificar igualdade)
                        next_state <= BRANCH;

                    when OP_JUMP =>                  -- Jump incondicional
                        next_state <= JUMP;

                    when OP_LOAD | OP_STORE =>       -- Load/Store
                        UlaIN1 <= '1';              -- Endereço base (rs)
                        ulaIN2 <= "10";             -- Entrada B: imediato estendido
                        ALUOp   <= "000";            -- Soma (base + offset)
                        next_state <= MEM;

                    when others =>
                        next_state <= FETCH;         -- Instrução inválida
                end case;

            -- Estado MEM: Acesso à memória (load/store)
            when MEM =>
                if opcode = OP_LOAD then
                    MemRead <= '1';                  -- Lê memória de dados
                    next_state <= WRITE_BACK;
                elsif opcode = OP_STORE then
                    MemWrite <= '1';                 -- Escreve na memória
                    next_state <= FETCH;
                end if;

            -- Estado WRITE_BACK: Write-back para registradores
            when WRITE_BACK =>
                RegWrite <= '1';                     -- Habilita escrita
                RegDst   <= '1' when (opcode = OP_ADD or opcode = OP_SUB or 
                                     opcode = OP_AND or opcode = OP_OR) else '0';
                MemtoReg <= '1' when opcode = OP_LOAD else '0';  -- Dado da memória
                next_state <= FETCH;

            -- Estado BRANCH: Atualiza PC se BEQ for verdadeiro
            when BRANCH =>
                PCSource <= "01";                    -- Se ALUResult == 0 (BEQ)
                PCWrite  <= '1';                     -- Atualiza PC
                next_state <= FETCH;

            -- Estado JUMP: Atualiza PC para jump
            when JUMP =>
                PCSource <= "10";                    -- Endereço do jump
                PCWrite  <= '1';                     -- Atualiza PC
                next_state <= FETCH;

            when others =>
                next_state <= FETCH;
        end case;
    end process;

end Behavioral;