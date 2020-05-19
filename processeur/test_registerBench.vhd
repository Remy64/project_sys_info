--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:57:53 05/12/2020
-- Design Name:   
-- Module Name:   /home/rbigue-c/registerBench/test_registerBench.vhd
-- Project Name:  registerBench
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: registerBench
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
 
ENTITY test_registerBench IS
END test_registerBench;
 
ARCHITECTURE behavior OF test_registerBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT registerBench
    PORT(
         tA : IN  std_logic_vector(3 downto 0);
         tB : IN  std_logic_vector(3 downto 0);
         tW : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal tA : std_logic_vector(3 downto 0) := (others => '0');
   signal tB : std_logic_vector(3 downto 0) := (others => '0');
   signal tW : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: registerBench PORT MAP (
          tA => tA,
          tB => tB,
          tW => tW,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
		
		RST <= '1' after  150 ns, '0' after 180 ns;
		
		W <= '1' after 200 ns, '0' after 450 ns;
		
		tW <= "1100" after 250 ns, "0100" after 350 ns;
		
		DATA <= "10101000" after 300 ns, "00001111" after 400 ns;
		
		tA <= "1100" after 500 ns;
		
		tB <= "0100" after 550 ns;

      wait;
   end process;

END;
