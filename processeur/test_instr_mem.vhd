--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:47:46 05/19/2020
-- Design Name:   
-- Module Name:   /home/jb/Documents/Algo/archi_mat/processeur/test_instr_mem.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: instr_mem
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_instr_mem IS
END test_instr_mem;
 
ARCHITECTURE behavior OF test_instr_mem IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instr_mem
    PORT(
         ADDR : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         OUT_DATA : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADDR : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT_DATA : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instr_mem PORT MAP (
          ADDR => ADDR,
          CLK => CLK,
          OUT_DATA => OUT_DATA
        );

   -- Clock process definitions
   CLK_process :process
   begin
      CLK <= '0';
      wait for CLK_period/2;
      CLK <= '1';
      wait for CLK_period/2;
   end process;

	ADDR <= X"00" after 100 ns, X"01" after 200 ns, X"02" after 300 ns;

END;
