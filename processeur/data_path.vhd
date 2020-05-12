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
    port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC);
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
	 
	 signal IP : STD_LOGIC_VECTOR (7 downto 0);
	 signal next_IP : STD_LOGIC_VECTOR (7 downto 0);
	 signal INSTR_DATA : STD_LOGIC_VECTOR (31 downto 0);
	 signal OP_DI : STD_LOGIC_VECTOR (7 downto 0);
	 signal A_DI : STD_LOGIC_VECTOR (7 downto 0);
	 signal B_DI : STD_LOGIC_VECTOR (7 downto 0);
	 signal C_DI : STD_LOGIC_VECTOR (7 downto 0);
	 signal OP_EX : STD_LOGIC_VECTOR (7 downto 0);
	 signal A_EX : STD_LOGIC_VECTOR (7 downto 0);
	 signal B_EX : STD_LOGIC_VECTOR (7 downto 0);
	 signal C_EX : STD_LOGIC_VECTOR (7 downto 0);
	 signal OP_MEM : STD_LOGIC_VECTOR (7 downto 0);
	 signal A_MEM : STD_LOGIC_VECTOR (7 downto 0);
	 signal B_MEM : STD_LOGIC_VECTOR (7 downto 0);
	 signal C_MEM : STD_LOGIC_VECTOR (7 downto 0);
	 signal OP_RE : STD_LOGIC_VECTOR (7 downto 0);
	 signal A_RE : STD_LOGIC_VECTOR (7 downto 0);
	 signal B_RE : STD_LOGIC_VECTOR (7 downto 0);
	 signal C_RE : STD_LOGIC_VECTOR (7 downto 0);
	 signal B_DI_MUX : STD_LOGIC_VECTOR (7 downto 0);
	 signal B_EX_MUX : STD_LOGIC_VECTOR (7 downto 0);
	 signal W : STD_LOGIC;
	 signal QA : STD_LOGIC_VECTOR (7 downto 0);
	 signal QB : STD_LOGIC_VECTOR (7 downto 0);
	 signal Ctr_Alu : STD_LOGIC_VECTOR (2 downto 0);
	 signal S : STD_LOGIC_VECTOR (7 downto 0);
	 
begin
    -- incrementation du pointeur d'instruction sur front montant
	 process
	 begin
	     wait until CLK'EVENT and CLK = '1';
		  next_IP <= std_logic_vector(unsigned(IP) + 1);
	 end process;
	 IP <= next_IP;
	 
	 -- memoire d'instructions
    data_instr_comp : data_instr PORT MAP(CLK,
	                                       IP,
														INSTR_DATA);

    -- interface chargement des instructions / décodage des instructions
	 li_di_interface : pipe PORT MAP(CLK,
	                                 INSTR_DATA(31 downto 24),
												INSTR_DATA(23 downto 16),
												INSTR_DATA(15 downto 8),
												INSTR_DATA(7  downto 0),
												OP_DI,
												A_DI,
												B_DI,
												C_DI);

    -- banc de registres
    register_bench_comp : registerBench PORT MAP(B_DI, --@A
                                                 C_DI, --@B
																 A_RE, --@W
																 W, --W
																 B_RE, --DATA
																 RST,
																 CLK,
																 QA, --QA
																 QB); --QB

    -- MUX pipe DI
    B_DI_MUX <= B_DI when OP_DI = X"06" else QA; --X"06" <=> AFC

    -- interface décodage des instructions / exécution des instructions
    di_ex_interface : pipe PORT MAP(CLK,
                                    OP_DI,
                                    A_DI,
												B_DI_MUX,
												C_DI,
												OP_EX,
												A_EX,
												B_EX,
												C_EX);
							  
    -- LC pipe EX
	 Ctrl_Alu <= "000" when OP_EX = X"01" else
                "001" when OP_EX = X"03" else
					 "002";
											
    -- unité arithmético-logique
    ual : UAL PORT MAP( Ctrl_Alu,
                        B_EX, --A
                        C_EX, --B
			               CLK,
                        OPEN,
                        OPEN,
                        OPEN,
                        OPEN,
                        S);
								
    -- MUX pipe EX
	 B_EX_MUX <= S when OP_DI = X"01" or
	                    OP_DI = X"03" or
							  OP_DI = X"02" else B_EX;

    -- interface exécution des instructions / mémoire
    ex_mem_interface : pipe PORT MAP(CLK,
	                                  OP_EX,
												 A_EX,
												 B_EX_MUX,
												 C_EX,
												 OP_MEM,
												 A_MEM,
												 B_MEM,
												 C_MEM);
												 
    -- interface mémoire / écriture des registres
    mem_re_interface : pipe PORT MAP(CLK,
	                                  OP_MEM,
												 A_MEM,
												 B_MEM,
												 C_MEM,
												 OP_RE,
												 A_RE,
												 B_RE,
												 C_RE);

    -- LC pipe RE
	 W <= '1' when OP_RE = X"06" else '0';

end Behavioral;