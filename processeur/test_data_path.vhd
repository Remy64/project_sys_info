--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:55:46 05/19/2020
-- Design Name:   
-- Module Name:   /home/jb/Documents/Algo/archi_mat/processeur/test_data_path.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_path
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
 
ENTITY test_data_path IS
END test_data_path;
 
ARCHITECTURE behavior OF test_data_path IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_path
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         ADDR_W_OUT : OUT std_logic_vector (3 downto 0);
			W_OUT : OUT std_logic;
			DATA_OUT : OUT std_logic_vector (7 downto 0));
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '1';
   signal CLK : std_logic := '0';
	
	--Outputs
   signal ADDR_W_OUT : std_logic_vector (3 downto 0);
   signal W_OUT : std_logic;
   signal DATA_OUT : std_logic_vector (7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_path PORT MAP (
          RST => RST,
          CLK => CLK,
          ADDR_W_OUT => ADDR_W_OUT,
			 W_OUT => W_OUT,
			 DATA_OUT => DATA_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	
	RST <= '1' after 100 ns;

END;