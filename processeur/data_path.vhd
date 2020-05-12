----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:11:59 05/04/2020 
-- Design Name: 
-- Module Name:    data_path - Behavioral 
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

entity data_path is
    port ( IP : in STD_LOGIC_VECTOR (7 downto 0),
           CLK : in STD_LOGIC );
end data_path;

architecture Behavioral of data_path is
    component instr_mem is
        port ( CLK : in  STD_LOGIC;
		         ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
               OUT_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
    end component;
	 
	 component pipe is
	     port ( CLK : in STD_LOGIC;
               OP_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               A_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               B_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               C_IN : in  STD_LOGIC_VECTOR (7 downto 0);
               OP_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
               A_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
               B_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
               C_OUT : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component registerBench is
        port ( tA : in  STD_LOGIC_VECTOR (3 downto 0);
               tB : in  STD_LOGIC_VECTOR (3 downto 0);
               tW : in  STD_LOGIC_VECTOR (3 downto 0);
               W : in  STD_LOGIC;
               DATA : in  STD_LOGIC_VECTOR (7 downto 0);
               RST : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
               QA : out  STD_LOGIC_VECTOR (7 downto 0);
               QB : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
	 
	 component UAL is
	     port ( Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
               A : in  STD_LOGIC_VECTOR (7 downto 0);
               B : in  STD_LOGIC_VECTOR (7 downto 0);
			      CLK : in  STD_LOGIC;
               N : out  STD_LOGIC;
               O : out  STD_LOGIC;
               Z : out  STD_LOGIC;
               C : out  STD_LOGIC;
               S : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
	 
    component data_mem is
        port ( ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
               IN_DATA : in  STD_LOGIC_VECTOR (7 downto 0);
               RW : in  STD_LOGIC;
               RST : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
               OUT_DATA : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
begin
    data_instr_comp : data_instr PORT MAP(CLK,
	                                       IP,
														INSTR_DATA);
														
	 li_di_interface : pipe PORT MAP(CLK,
	                                 INSTR_DATA(31 downto 24),
												INSTR_DATA(23 downto 16),
												INSTR_DATA(15 downto 8),
												INSTR_DATA(7  downto 0),
												OP_DI,
												A_DI,
												B_DI,
												C_DI);

    register_bench_comp : registerBench PORT MAP(
    begin
	 process
        wait until CLK'EVENT and CLK = '1';
    end process;

end Behavioral;
