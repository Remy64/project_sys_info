--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:47:27 05/19/2020
-- Design Name:   
-- Module Name:   /home/jb/Documents/Algo/archi_mat/processeur/test_pipe.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pipe
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
 
ENTITY test_pipe IS
END test_pipe;
 
ARCHITECTURE behavior OF test_pipe IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pipe
    PORT(
         CLK : IN  std_logic;
         OP_IN : IN  std_logic_vector(7 downto 0);
         A_IN : IN  std_logic_vector(7 downto 0);
         B_IN : IN  std_logic_vector(7 downto 0);
         C_IN : IN  std_logic_vector(7 downto 0);
         OP_OUT : OUT  std_logic_vector(7 downto 0);
         A_OUT : OUT  std_logic_vector(7 downto 0);
         B_OUT : OUT  std_logic_vector(7 downto 0);
         C_OUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal OP_IN : std_logic_vector(7 downto 0) := (others => '0');
   signal A_IN : std_logic_vector(7 downto 0) := (others => '0');
   signal B_IN : std_logic_vector(7 downto 0) := (others => '0');
   signal C_IN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal OP_OUT : std_logic_vector(7 downto 0);
   signal A_OUT : std_logic_vector(7 downto 0);
   signal B_OUT : std_logic_vector(7 downto 0);
   signal C_OUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pipe PORT MAP (
          CLK => CLK,
          OP_IN => OP_IN,
          A_IN => A_IN,
          B_IN => B_IN,
          C_IN => C_IN,
          OP_OUT => OP_OUT,
          A_OUT => A_OUT,
          B_OUT => B_OUT,
          C_OUT => C_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   OP_IN <= X"02", X"03" after 102 ns, X"04" after 202 ns, X"05" after 302 ns;
   A_IN <= X"01", X"02" after 102 ns, X"03" after 202 ns;
	B_IN <= X"00", X"01" after 102 ns;

END;
