-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2022 09:03:25 PM
-- Design Name: 
-- Module Name: test_new - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port (clk : in STD_LOGIC;
    btn : in STD_LOGIC_VECTOR(4 downto 0);
    sw : in STD_LOGIC_VECTOR(15 downto 0);
    led : out STD_LOGIC_VECTOR(15 downto 0);
    an : out STD_LOGIC_VECTOR(3 downto 0);
    cat : out STD_LOGIC_VECTOR(6 downto 0));
end test_env;

architecture Structural of test_env is 

component MPG is
   Port (clk : in STD_LOGIC;
         btn : in STD_LOGIC;
          enable : out STD_LOGIC);
end component;

component SSD is
     Port (Digit : in std_logic_vector(15 downto 0);
           clk : in std_logic;
           cat : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(3 downto 0));
end component;

component UnitateIF is
    Port (
        jumpAddr : in std_logic_vector(15 downto 0);
        branchAddr : in std_logic_vector(15 downto 0);
        jump : in std_logic;
        pcSrc : in std_logic;
        enablePC : in std_logic;
        memReset : in std_logic;
        clk : in std_logic;
        outPC : out std_logic_vector (15 downto 0);
        instruction : out std_logic_vector (15 downto 0)
        );
end component;

component MEM is
Port (aluRes : in std_logic_vector(15 downto 0);
         RD2 : in std_logic_vector(15 downto 0);
       memWrite : in std_logic;
       clk : in std_logic;
       enable : in std_logic;
        memdata : out std_logic_vector (15 downto 0)
        );
end component;

component ID is
    Port (instr: in std_logic_vector(15 downto 0);
        regWrite: in std_logic;
        --regDst : in std_logic;
        clk: in std_logic;
        ext_op: in std_logic;
        enable : std_logic;
        wa : in std_logic_vector(2 downto 0);
        wd : in std_logic_vector(15 downto 0);
        rd1 : out std_logic_vector(15 downto 0);
        rd2 : out std_logic_vector(15 downto 0);
        ext_Imm: out std_logic_vector(15 downto 0);
        func : out std_logic_vector(2 downto 0);
        sa : out std_logic;
        rt: out std_logic_vector(2 downto 0);
         rd: out std_logic_vector(2 downto 0)
        );
end component;


component UC is
    Port ( OpCode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           Branch : out STD_LOGIC;
           ALUsrc : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUop : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component Alu is
  Port (RD1 : in std_logic_vector(15 downto 0);
         RD2 : in std_logic_vector(15 downto 0);
         PCnext : in std_logic_vector(15 downto 0);
        Ext_Imm : in std_logic_vector(15 downto 0);
       func : in std_logic_vector(2 downto 0);
        sa : in std_logic;
       alusrc : in std_logic;
       RegDst: in std_logic;
       rt: in std_logic_vector(2 downto 0);
       rd: in std_logic_vector(2 downto 0);
        aluop : in std_logic_vector(1 downto 0);
        res : out std_logic_vector (15 downto 0) ;
        branch : out std_logic_vector (15 downto 0);
         zero :out  std_logic;
         WriteAddress: out std_logic_vector(2 downto 0));
end component;

signal enableMPG: std_logic;
signal resetMPG: std_logic;
signal memDataS :  std_logic_vector (15 downto 0);
signal instruction1 :  std_logic_vector (15 downto 0);
signal toPrint :std_logic_vector (15 downto 0);
----
signal PCnext: std_logic_vector(15 downto 0);
signal jmpAddr: std_logic_vector(15 downto 0);
--
signal jmpS: std_logic;
signal PCsrc: std_logic;
signal branchS: std_logic;
--
signal ext : std_logic_vector(15 downto 0);
signal r1 : std_logic_vector(15 downto 0);
signal funcS: std_logic_vector(2 downto 0);
signal rtS: std_logic_vector(2 downto 0);
signal rdS: std_logic_vector(2 downto 0);
signal WriteAddressS: std_logic_vector(2 downto 0);
signal AluOPs: std_logic_vector(1 downto 0);
signal aluSrcS : std_logic;
signal r2 : std_logic_vector(15 downto 0);
signal saS : std_logic;
signal zeroS: std_logic;
signal branchAdr:std_logic_vector(15 downto 0);
signal resS: std_logic_vector(15 downto 0);
--
signal RegDstS: std_logic;
signal ExtOpS : std_logic;
signal MemWriteS: std_logic;
signal MemToRegS: std_logic;
signal RegWriteS: std_logic;

signal IF_ID: std_logic_vector(31 downto 0);
signal ID_EX: std_logic_vector(82 downto 0);
signal EX_MEM: std_logic_vector(55 downto 0);
signal MEM_WB: std_logic_vector(36 downto 0);
--
signal wdS: std_logic_vector(15 downto 0);


begin

c1: MPG port map(clk=>clk, btn=>btn(0), enable=>enableMPG);
c2: MPG port map(clk=>clk, btn=>btn(1), enable=>resetMPG);

PCsrc<= EX_MEM(3) and  EX_MEM(20);

c3: unitateIF port map (jumpAddr=>jmpAddr,
                        branchAddr=>EX_MEM(19 downto 4),
                        jump=>jmpS,
                        pcSrc=>PCsrc,
                        enablePC=>enableMPG,
                         memReset=>resetMPG,
                         clk=>clk,
                         outPC=>PCnext,
                         instruction=>instruction1);

jmpAddr<="000" & IF_ID(28 downto 16);


c4: ALU port map (RD1=> ID_EX(41 downto 26),
                RD2=> ID_EX(57 downto 42),
                PCnext=> ID_EX(25 downto 10),  
                Ext_Imm=>ID_EX(73 downto 58) , 
                func=> ID_EX(76 downto 74) , 
                sa=> ID_EX(9), 
                alusrc=> ID_EX(1) , 
                RegDst => ID_EX(0),
                rt =>  ID_EX(79 downto 77),
                rd =>  ID_EX(82 downto 80),
                aluop => ID_EX(8 downto 7), 
                res=> resS, 
                branch => branchAdr , 
                zero=> zeroS, 
                WriteAddress =>  WriteAddressS);

c5: UC port map ( OpCode => IF_ID(31 downto 29),
           RegDst => RegDstS,
           ExtOp => ExtOpS,
           Branch => branchS,
           ALUsrc => aluSrcS,
           Jump => jmpS,
           ALUop => AluOPs,
           MemWrite=> MemWriteS,
           MemToReg => MemToRegS,
           RegWrite => RegWriteS);

c6: ID port map (instr=>IF_ID(31 downto 16),
        regWrite=>MEM_WB(1),
        clk=>clk,
        ext_op => ExtOpS,
        enable => enableMPG,
        wa => MEM_WB(36 downto 34),
        wd => wdS,
        rd1  => r1,
        rd2 => r2,
        ext_Imm => ext,
        func => funcS,
        sa => saS,
        rt => rtS,
        rd => rdS);

c7: MEM port map (aluRes =>  EX_MEM(36 downto 21),
         RD2 => EX_MEM(52 downto 37),
       memWrite => EX_MEM(2),
       clk => clk,
       enable => enableMPG,
        memdata => memDataS
        );

process (MEM_WB(0),MEM_WB(17 downto 2),MEM_WB(33 downto 18)) 
    begin
        case MemToRegS is
        when '0'    => wdS <= MEM_WB(33 downto 18);
        when others => wdS <= MEM_WB(17 downto 2);
        end case;
        end process;

process (sw(7 downto 5),r1,r2,resS,wdS,memDataS,ext,PCnext,instruction1) 
    begin
        case sw(7 downto 5) is
        when "000"    => toPrint <= IF_ID(31 downto 16);
        when "001"    => toPrint <= IF_ID(15 downto 0);
        when "010"    => toPrint <= r1;
        when "011"    => toPrint <= r2;
        when "100"    => toPrint <= ext;
        when "101"    => toPrint <=  resS;
        when "110"    => toPrint <= memDataS;
        when others => toPrint <= wdS;
        end case;
        end process;
led(15 downto 0) <= "000000" & ID_EX(8 downto 7) & ID_EX(0)  & ExtOpS &  ID_EX(1) & ID_EX(2) & jmpS & ID_EX(3) & ID_EX(4) &  ID_EX(5);
c100: SSD port map(Digit => toPrint, clk => clk, cat => cat,an =>an);

 process(clk, enableMPG)
        begin
            if(enableMPG = '1') then
                if(rising_edge(clk)) then
                    IF_ID(15 downto 0) <= PCnext;
                    IF_ID(31 downto 16) <= instruction1;
                    
                    ID_EX(0) <= RegDstS;
                    ID_EX(1) <= ALUSrcS;
                    ID_EX(2) <= branchS;
                    ID_EX(8 downto 7) <= aluOpS;--
                    ID_EX(3) <= memWriteS;
                    ID_EX(4) <= memToRegS;
                    ID_EX(5) <= regWriteS;
                    ID_EX(9) <= saS;
                    ID_EX(25 downto 10) <= IF_ID(15 downto 0);
                    ID_EX(41 downto 26) <= r1;
                    ID_EX(57 downto 42) <= r2;
                    ID_EX(73 downto 58) <= ext;
                    ID_EX(76 downto 74) <= funcS;
                    ID_EX(79 downto 77) <= rtS;
                    ID_EX(82 downto 80) <= rdS;
                    
                    EX_MEM(0) <= ID_EX(4);
                    EX_MEM(1) <= ID_EX(5);
                    EX_MEM(2) <= ID_EX(3);
                    EX_MEM(3) <= ID_EX(2);
    
                    EX_MEM(19 downto 4) <= branchAdr;
                    EX_MEM(20) <= zeroS;
                    EX_MEM(36 downto 21) <= resS;
                    EX_MEM(52 downto 37) <= ID_EX(57 downto 42);
                    EX_MEM(55 downto 53) <= WriteAddressS;    
                    
                    MEM_WB(0) <= EX_MEM(0);
                    MEM_WB(1) <= EX_MEM(1);
                    MEM_WB(17 downto 2) <= memDataS;
                    MEM_WB(33 downto 18) <= EX_MEM(36 downto 21);
                    MEM_WB(36 downto 34) <= EX_MEM(55 downto 53);
                    
                end if;
            end if;
        end process;


end;