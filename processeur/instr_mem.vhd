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

type MEMORY_TYPE is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
constant memory : MEMORY_TYPE := (
    X"06050F00", -- AFC R5 15
    X"05010500", -- COP R1 R5
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
	 X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00", -- AFC R2 42
    X"06022A00"  -- AFC R2 42
);

begin
    process
    begin
        wait until CLK'EVENT and CLK='1';
        OUT_DATA <= memory(to_integer(unsigned(ADDR)));
    end process;
end Behavioral;
