----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:28:33 04/20/2020 
-- Design Name: 
-- Module Name:    UAL - Behavioral 
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

entity UAL is
    Port ( Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK : in  STD_LOGIC;
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end UAL;

architecture Behavioral of UAL is
	signal S_aux : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
begin
	-- ADD : 000
	-- SUB : 001
	-- MUL : 010
	-- DIV : 011
	
	-- Complément à 2, carry, overflow
	-- https://www.doc.ic.ac.uk/~eedwards/compsys/arithmetic/index.html
	-- http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt
	-- https://moodle-3a.insa-toulouse.fr/mod/forum/discuss.php?d=4636
	
	S_aux <=
	('0' & A) + ('0' & B) when Ctrl_Alu = "000" else
	('0' & A) - ('0' & B) when Ctrl_Alu = "001" else
	("00000" & A(3 downto 0)) * ("00000" & B(3 downto 0)) when Ctrl_Alu = "010";-- else
	--std_logic_vector(unsigned(A) / unsigned(B)) when Ctrl_Alu = "011"; -- "/" n'existe pas dans la librairie unsigned
	
	N <= S_aux(7) when Ctrl_Alu /= "010" else A(3) xor B(3);
	O <=
		'1'
			when (
				A(7) = B(7) and S_aux(7) /= A(7)
				and
				Ctrl_Alu = "000" --ADD
			) or (
				A(7) /= B(7) and S_aux(7) = B(7)
				and
				Ctrl_Alu = "001" --SUB
			) else
		'0';
	Z <= '1' when S_aux = "000000000" else '0';
	C <= S_aux(8) when Ctrl_Alu /= "010" else '0';
	S <= S_aux(7 downto 0);
		
end Behavioral;
