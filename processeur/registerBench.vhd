----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:35:05 04/20/2020 
-- Design Name: 
-- Module Name:    registerBench - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registerBench is
    Port ( tA : in  STD_LOGIC_VECTOR (3 downto 0);
           tB : in  STD_LOGIC_VECTOR (3 downto 0);
           tW : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
end registerBench;

architecture Behavioral of registerBench is

type registerTable is array (3 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
signal registers : registerTable;

begin
	process
	begin
	wait until CLK'event and CLK = '1';
	if RST = '0' then
		QA <= "00000000";
		QB <= "00000000";
	else
		if W = '1' then
			registers(to_integer(unsigned(tW))) <= DATA;
		end if;
		QA <= registers(to_integer(unsigned(tA)));
		QB <= registers(to_integer(unsigned(tB)));
	end if;
	end process;
end Behavioral;
			