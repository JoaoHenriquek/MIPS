library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        clk     : in  STD_LOGIC;   -- Clock
        reset   : in  STD_LOGIC    -- Reset
    );
end top_level;

architecture Behavioral of top_level is
    -- Componentes
    component control_unit is
        Port (
            clk, reset : in  STD_LOGIC;
            opcode     : in  STD_LOGIC_VECTOR(3 downto 0);
            RegDst, RegWrite, RegRead, ALUSrcA : out STD_LOGIC;
            ALUSrcB    : out STD_LOGIC_VECTOR(1 downto 0);
            ALUOp      : out STD_LOGIC_VECTOR(2 downto 0);
            MemRead, MemWrite, MemtoReg, PCWrite : out STD_LOGIC;
            PCSource   : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    
    component datapath is
        Port (
            clk, reset : in  STD_LOGIC;
            RegDst, RegWrite, RegRead, ALUSrcA : in  STD_LOGIC;
            ALUSrcB    : in  STD_LOGIC_VECTOR(1 downto 0);
            ALUOp      : in  STD_LOGIC_VECTOR(2 downto 0);
            MemRead, MemWrite, MemtoReg : in  STD_LOGIC;
            PCSource   : in  STD_LOGIC_VECTOR(1 downto 0);
            instr_out  : out STD_LOGIC_VECTOR(15 downto 0);
            address    : out STD_LOGIC_VECTOR(15 downto 0);
            data_in    : in  STD_LOGIC_VECTOR(15 downto 0);
            data_out   : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    -- Memória (Instruções e Dados)
    type Memory_Type is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
    signal memory : Memory_Type := (
        0 => "0000000100000000",  -- Exemplo: ADD R0, R1, R2
        1 => "0110000011111111",  -- Exemplo: LW R0, 0xFF(R1)
        others => (others => '0')
    );
    
    -- Sinais de interconexão
    signal RegDst, RegWrite, RegRead, ALUSrcA : STD_LOGIC;
    signal ALUSrcB : STD_LOGIC_VECTOR(1 downto 0);
    signal ALUOp   : STD_LOGIC_VECTOR(2 downto 0);
    signal MemRead, MemWrite, MemtoReg, PCWrite : STD_LOGIC;
    signal PCSource : STD_LOGIC_VECTOR(1 downto 0);
    signal instr_out, address, data_out, data_in : STD_LOGIC_VECTOR(15 downto 0);
begin
    -- Instanciação da UC
    UC: control_unit port map (
        clk => clk,
        reset => reset,
        opcode => instr_out(15 downto 12), -- Opcode (bits 15-12)
        RegDst => RegDst,
        RegWrite => RegWrite,
        RegRead => RegRead,
        ALUSrcA => ALUSrcA,
        ALUSrcB => ALUSrcB,
        ALUOp => ALUOp,
        MemRead => MemRead,
        MemWrite => MemWrite,
        MemtoReg => MemtoReg,
        PCWrite => PCWrite,
        PCSource => PCSource
    );
    
    -- Instanciação do Datapath
    DP: datapath port map (
        clk => clk,
        reset => reset,
        RegDst => RegDst,
        RegWrite => RegWrite,
        RegRead => RegRead,
        ALUSrcA => ALUSrcA,
        ALUSrcB => ALUSrcB,
        ALUOp => ALUOp,
        MemRead => MemRead,
        MemWrite => MemWrite,
        MemtoReg => MemtoReg,
        PCSource => PCSource,
        instr_out => instr_out,
        address => address,
        data_in => data_in,
        data_out => data_out
    );
    
    -- Conexão com a memória
    process(clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                memory(to_integer(unsigned(address))) <= data_out;
            end if;
            data_in <= memory(to_integer(unsigned(address)));
        end if;
    end process;
end Behavioral;