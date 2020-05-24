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
           CLK : in STD_LOGIC;
           ADDR_W_OUT : out STD_LOGIC_VECTOR (3 downto 0);
			  W_OUT : out STD_LOGIC;
			  DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);

			  IP_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           next_IP_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           INSTR_DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
           OP_DI_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           A_DI_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_DI_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           C_DI_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           OP_EX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           A_EX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_EX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           C_EX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           OP_MEM_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           A_MEM_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_MEM_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           C_MEM_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           OP_RE_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           A_RE_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_RE_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           C_RE_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_DI_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_EX_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           B_MEM_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
	        RW_OUT : out STD_LOGIC;
           QA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           QB_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu_OUT : out STD_LOGIC_VECTOR (2 downto 0);
           S_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           ADDR_DATA_MEM_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
	        MEM_DATA_OUT_OUT : out STD_LOGIC_VECTOR (7 downto 0)
			  
			  );
end data_path;

architecture Behavioral of data_path is
    component instr_mem is
        port (CLK : in  STD_LOGIC;
              ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
              OUT_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component pipe is
        port (CLK : in STD_LOGIC;
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
        port (tA : in  STD_LOGIC_VECTOR (3 downto 0);
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
        port (Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
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
        port (ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
              IN_DATA : in  STD_LOGIC_VECTOR (7 downto 0);
              RW : in  STD_LOGIC;
              RST : in  STD_LOGIC;
              CLK : in  STD_LOGIC;
              OUT_DATA : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal IP : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); -- read first instruction first
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
    signal B_MEM_MUX : STD_LOGIC_VECTOR (7 downto 0);
    signal W : STD_LOGIC;
	 signal RW : STD_LOGIC;
    signal QA : STD_LOGIC_VECTOR (7 downto 0);
    signal QB : STD_LOGIC_VECTOR (7 downto 0);
    signal Ctrl_Alu : STD_LOGIC_VECTOR (2 downto 0);
    signal S : STD_LOGIC_VECTOR (7 downto 0);
    signal ADDR_DATA_MEM_MUX : STD_LOGIC_VECTOR (7 downto 0);
	 signal MEM_DATA_OUT : STD_LOGIC_VECTOR (7 downto 0);

begin
    -- incrementation du pointeur d'instruction sur front montant
    process
    begin
        wait until CLK'EVENT and CLK = '1';
        if to_integer(unsigned(IP)) = 34 then
            next_IP <= (others => '0');
        else
            next_IP <= std_logic_vector(to_unsigned(to_integer(unsigned(IP)) + 1, 8));
        end if;
    end process;
    IP <= next_IP;

    -- memoire d'instructions
    instr_mem_comp : instr_mem PORT MAP(CLK,
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
    register_bench_comp : registerBench PORT MAP(B_DI(3 downto 0), --@A
                                                 C_DI(3 downto 0), --@B
                                                 A_RE(3 downto 0), --@W
                                                 W,
                                                 B_RE, --DATA
                                                 RST,
                                                 CLK,
                                                 QA,
                                                 QB);

    -- MUX pipe DI
    B_DI_MUX <= B_DI when OP_DI = X"06" or OP_DI = X"07" else QA; -- pour les instructions dont le deuxième argument n'est pas un numéro de registre, on transmet directement l'argument

    -- interface décodage des instructions / exécution des instructions
    di_ex_interface : pipe PORT MAP(CLK,
                                    OP_DI,
                                    A_DI,
                                    B_DI_MUX,
                                    QB,
                                    OP_EX,
                                    A_EX,
                                    B_EX,
                                    C_EX);

    -- LC pipe EX
    Ctrl_Alu <= "000" when OP_EX = X"01" else
                "001" when OP_EX = X"03" else
                "010"; -- on mappe les codes des instructions sur les codes des opérations de l'UAL

    -- unité arithmético-logique
    ual_comp : UAL PORT MAP(Ctrl_Alu,
                            B_EX, --A
                            C_EX, --B
                            CLK,
                            OPEN,
                            OPEN,
                            OPEN,
                            OPEN,
                            S);

    -- MUX pipe EX
    B_EX_MUX <= S when OP_EX = X"01" or
                       OP_EX = X"03" or
                       OP_EX = X"02" else B_EX; -- pour les opérations arithmétiques, on met la sortie de l'UAL

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

    RW <= '1' when OP_MEM = X"08" else '0'; -- écriture pour "STORE", lecture pour "LOAD"

    ADDR_DATA_MEM_MUX <= A_MEM when OP_MEM = X"08" else B_MEM; -- pour "STORE", A contient l'adresse d'écriture en mémoire, pour "LOAD", B contient l'adresse de lecture

    data_mem_comp : data_mem PORT MAP(ADDR_DATA_MEM_MUX,
                                      B_MEM, -- IN_DATA
                                      RW,
                                      RST,
                                      CLK,
                                      MEM_DATA_OUT);

    B_MEM_MUX <= B_MEM when OP_MEM /= X"07" else MEM_DATA_OUT; -- pour "LOAD", on renvoie les données lues dans la mémoire sur B

    -- interface mémoire / écriture des registres
    mem_re_interface : pipe PORT MAP(CLK,
                                     OP_MEM,
                                     A_MEM,
                                     B_MEM_MUX,
                                     C_MEM,
                                     OP_RE,
                                     A_RE,
                                     B_RE,
                                     C_RE);

    -- LC pipe RE
    --W <= '1' when OP_RE /= X"08" and OP_RE /= X"00" else '0'; -- on ecrit dans un registre pour toutes les instructions sauf "STORE"
    --W <= '1' when OP_RE = X"01"
    --           or OP_RE = X"02"
    --           or OP_RE = X"03"
    --           or OP_RE = X"04"
    --           or OP_RE = X"05"
    --           or OP_RE = X"06"
    --           or OP_RE = X"07"
    --else '0'; -- on ecrit dans un registre pour toutes les instructions sauf "STR" et "NOP"
	 W <= '1' when OP_RE >= X"01" and OP_RE <= X"07" else '0'; -- on ecrit dans un registre pour toutes les instructions sauf "STR" et "NOP"
	 
    -- sorties
    ADDR_W_OUT <= A_RE(3 downto 0);
    W_OUT <= W;
    DATA_OUT <= B_RE;
	 
	 -- sorties test
    IP_OUT <= IP;
    next_IP_OUT <= next_IP;
    INSTR_DATA_OUT <= INSTR_DATA;
    OP_DI_OUT <= OP_DI;
    A_DI_OUT <= A_DI;
    B_DI_OUT <= B_DI;
    C_DI_OUT <= C_DI;
    OP_EX_OUT <= OP_EX;
    A_EX_OUT <= A_EX;
    B_EX_OUT <= B_EX;
    C_EX_OUT <= C_EX;
    OP_MEM_OUT <= OP_MEM;
    A_MEM_OUT <= A_MEM;
    B_MEM_OUT <= B_MEM;
    C_MEM_OUT <= C_MEM;
    OP_RE_OUT <= OP_RE;
    A_RE_OUT <= A_RE;
    B_RE_OUT <= B_RE;
    C_RE_OUT <= C_RE;
    B_DI_MUX_OUT <= B_DI_MUX;
    B_EX_MUX_OUT <= B_EX_MUX;
    B_MEM_MUX_OUT <= B_MEM_MUX;
	 RW_OUT <= RW;
    QA_OUT <= QA;
    QB_OUT <= QB;
    Ctrl_Alu_OUT <= Ctrl_Alu;
    S_OUT <= S;
    ADDR_DATA_MEM_MUX_OUT <= ADDR_DATA_MEM_MUX;
	 MEM_DATA_OUT_OUT <= MEM_DATA_OUT;

end Behavioral;
