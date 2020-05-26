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
         QA_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
         QB_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
         ADDR_W_OUT : OUT std_logic_vector (3 downto 0);
			W_OUT : OUT std_logic;
			DATA_OUT : OUT std_logic_vector (7 downto 0)

--         ;
--         IP_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         next_IP_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         INSTR_DATA_OUT : OUT STD_LOGIC_VECTOR (31 downto 0);
--         OP_DI_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         A_DI_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_DI_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         C_DI_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         OP_EX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         A_EX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_EX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         C_EX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         OP_MEM_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         A_MEM_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_MEM_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         OP_RE_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         A_RE_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_RE_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_DI_MUX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_EX_MUX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         B_MEM_MUX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         RW_OUT : OUT STD_LOGIC;
--         Ctrl_Alu_OUT : OUT STD_LOGIC_VECTOR (2 downto 0);
--         S_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         ADDR_DATA_MEM_MUX_OUT : OUT STD_LOGIC_VECTOR (7 downto 0);
--         MEM_DATA_OUT_OUT : OUT STD_LOGIC_VECTOR (7 downto 0)
		);
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '1';
   signal CLK : std_logic := '0';
	
	--Outputs
   signal QA_OUT : STD_LOGIC_VECTOR (7 downto 0);
   signal QB_OUT : STD_LOGIC_VECTOR (7 downto 0);
   signal ADDR_W_OUT : std_logic_vector (3 downto 0);
   signal W_OUT : std_logic;
   signal DATA_OUT : std_logic_vector (7 downto 0);
	
	--Internal signals
--   signal IP_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal next_IP_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal INSTR_DATA_OUT : STD_LOGIC_VECTOR (31 downto 0);
--   signal OP_DI_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal A_DI_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_DI_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal C_DI_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal OP_EX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal A_EX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_EX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal C_EX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal OP_MEM_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal A_MEM_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_MEM_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal OP_RE_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal A_RE_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_RE_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_DI_MUX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_EX_MUX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal B_MEM_MUX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal RW_OUT : STD_LOGIC;
--   signal Ctrl_Alu_OUT : STD_LOGIC_VECTOR (2 downto 0);
--   signal S_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal ADDR_DATA_MEM_MUX_OUT : STD_LOGIC_VECTOR (7 downto 0);
--   signal MEM_DATA_OUT_OUT : STD_LOGIC_VECTOR (7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_path PORT MAP (
          RST => RST,
          CLK => CLK,
          QA_OUT => QA_OUT,
          QB_OUT => QB_OUT,
          ADDR_W_OUT => ADDR_W_OUT,
          W_OUT => W_OUT,
          DATA_OUT => DATA_OUT

--          ,
--          IP_OUT => IP_OUT,
--          next_IP_OUT => next_IP_OUT,
--          INSTR_DATA_OUT => INSTR_DATA_OUT,
--          OP_DI_OUT => OP_DI_OUT,
--          A_DI_OUT => A_DI_OUT,
--          B_DI_OUT => B_DI_OUT,
--          C_DI_OUT => C_DI_OUT,
--          OP_EX_OUT => OP_EX_OUT,
--          A_EX_OUT => A_EX_OUT,
--          B_EX_OUT => B_EX_OUT,
--          C_EX_OUT => C_EX_OUT,
--          OP_MEM_OUT => OP_MEM_OUT,
--          A_MEM_OUT => A_MEM_OUT,
--          B_MEM_OUT => B_MEM_OUT,
--          OP_RE_OUT => OP_RE_OUT,
--          A_RE_OUT => A_RE_OUT,
--          B_RE_OUT => B_RE_OUT,
--          B_DI_MUX_OUT => B_DI_MUX_OUT,
--          B_EX_MUX_OUT => B_EX_MUX_OUT,
--          B_MEM_MUX_OUT => B_MEM_MUX_OUT,
--          RW_OUT => RW_OUT,
--          Ctrl_Alu_OUT => Ctrl_Alu_OUT,
--          S_OUT => S_OUT,
--          ADDR_DATA_MEM_MUX_OUT => ADDR_DATA_MEM_MUX_OUT,
--          MEM_DATA_OUT_OUT => MEM_DATA_OUT_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	
	RST <= '0' after 350 ns, '1' after 400 ns;

END;
