----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:25 04/30/2020 
-- Design Name: 
-- Module Name:    instr_mem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_mem is
    Port ( ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           OUT_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end instr_mem;

architecture Behavioral of instr_mem is

type MEMORY_TYPE is array(0 to 34) of STD_LOGIC_VECTOR(31 downto 0);
constant memory : MEMORY_TYPE := (
    X"06010300", -- AFC R1 3        (R1 = 3)
	 X"06020200", -- AFC R2 2        (R2 = 2)
	 X"00000000", -- NOP
	 X"00000000", -- NOP
	 X"00000000", -- NOP
	 X"00000000", -- NOP * attendre 4 ticks pour écriture dans registre
    X"01030102", -- ADD R3 R1 R2    (R3 = 3 + 2 = 5)
    X"03040102", -- SOU R4 R1 R2    (R4 = 3 - 2 = 1)
    X"02050102", -- MUL R5 R1 R2    (R5 = 3 * 2 = 6)
	 X"00000000", -- NOP
	 X"00000000", -- NOP * attendre 4 ticks pour écriture dans registre
    X"05060300", -- COP R6 R3       (R6 = R3 = 5)
	 X"00000000", -- NOP
	 X"00000000", -- NOP
	 X"00000000", -- NOP
	 X"00000000", -- NOP * attendre 4 ticks pour écriture dans registre
    X"08030600", -- STR M3 R6       (M3 = R6 = 5)
	 X"00000000", -- NOP
	 X"00000000", -- NOP
	 X"00000000", -- NOP * attendre 3 ticks pour écriture dans mémoire
    X"07070300", -- LDR R7 M3       (R7 = M3 = 5)
    X"00000000", -- NOP
    X"00000000", -- NOP
    X"00000000", -- NOP
    X"00000000", -- NOP * attendre 4 ticks pour écriture dans registre
    X"01010704", -- ADD R1 R7 R4    (R1 = R7 + R4 = 5 + 1 = 6)
    X"00000000", -- NOP
    X"00000000", -- NOP
    X"00000000", -- NOP
    X"00000000", -- NOP * attendre 4 ticks pour écriture dans registre
    X"01020105", -- ADD R2 R1 R5    (R2 = R1 + R5 = 6 + 6 = 12)
    X"00000000", -- NOP
    X"00000000", -- NOP
    X"00000000", -- NOP
    X"00000000"  -- NOP * attendre 4 tocks pour écriture dans registre 
	 -- Fin à 345 ns, reboucle ensuite
);

begin
    process
    begin
        wait until CLK'EVENT and CLK='1';
        OUT_DATA <= memory(to_integer(unsigned(ADDR)));
    end process;
end Behavioral;
