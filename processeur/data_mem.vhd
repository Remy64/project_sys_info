----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:37:53 04/30/2020 
-- Design Name: 
-- Module Name:    data_mem - Behavioral 
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

entity data_mem is
    Port ( ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           OUT_DATA : out  STD_LOGIC_VECTOR (7 downto 0));
end data_mem;

architecture Behavioral of data_mem is

type MEMORY_TYPE is array(0 to 31) of STD_LOGIC_VECTOR(7 downto 0);
signal memory : MEMORY_TYPE := (others=>(others=>'0'));

begin
	 memory <= (others=>(others=>'0')) when RST = '1';

    process
	 begin
        wait until CLK'EVENT and CLK='1';
		  if RW = '1' then
		      OUT_DATA <= memory(to_integer(unsigned(ADDR)));
		  else
            memory(to_integer(unsigned(ADDR))) <= IN_DATA;
		  end if;
    end process;

end Behavioral;
