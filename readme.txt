 instruções escolhidas:
ADD
SUB
LW
STORE
JUMP
BEQ /JEQ
OR
AND
BGT
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
Número de registradores:
4 registradores de 16 bits [r0 - r3]
r0 sempre zerado 
IR, A, B, PC separado, MDR
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Definição das instruções:
	As instruções serão de 16 bits.
Tipo R:
| op (4) | rs (2) | rt (2) | rd (2) | funct (6) |

ADD -> ADD r1, r2, r3 -> r1 + r2 = guarda em r3; op/funct 0000 000000
SUB -> SUB r1, r2, r3 -> r1 - r2 = guarda em r3 -> op/funct 0000 000001
OR -> OR r1, r2, r3 -> r1 = r2 || r3 -> op/funct 0000 000010
AND -> AND r1, r2 ,r3 -> r1 = r2 & r3 -> op/funct 0000 000011

------------------------------------------------------------------------------------------------

Tipo I:
| op (4) | rs (2) | rt (2) | adrss (8) |

	BEQ -> BEQ r1, r2, 20 -> se r1 == r2 PC = 20; op 0001

	LW e SW usam modo de endereçamento direto/indexado. 
	LW -> LW r1, r2, 25 -> r1 = mem[25 +r2]; op 0010.
	SW -> SW r1, r2, 25 -> salva r1 em MEM[25 +r2]; op 0011.


	tipo J:
	| op (4) | address (12) |
	JUMP -> J 25 -> PC = 25; op 0100
------------------------------------------------------------------------------------------------

Especificação da memória:
	tamanho da memória: 16 x256
	Utilize 1 memória.

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Problemas para resolver:
1° só 2 bit para registrador vai ficar justo
2° no branch só sobra 6 bit para endereçamento(se agnt mantiver os 16 bit na instrução)
3° falta fazer a logica pra entrada
