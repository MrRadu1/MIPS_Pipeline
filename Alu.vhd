----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 03:26:32 PM
-- Design Name: 
-- Module Name: Alu - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Alu is
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
end Alu;

architecture Behavioral of Alu is
signal resTemp : std_logic_vector(15 downto 0):=X"0000";
signal digits : std_logic_vector(15 downto 0);
signal ALUCtrl : std_logic_vector(2 downto 0);
begin
with resTemp select
   zero <= '1' when x"0000",
    '0' when others;
 
process(alusrc,  RD2, Ext_Imm)
        begin
            case alusrc is
            when '0'    => digits <= RD2;
            when others => digits <=   Ext_Imm;
            end case;
end process;

process(ALUOp, func)
begin
    case ALUOp is
        when "00" => ALUCtrl <= func; --tip R
        when "01" => ALUCtrl <= "000"; --addition
        when "10" => ALUCtrl <= "001";  --subtraction
        when others => ALUCtrl <= "101"; --OR 
    end case;
end process;

process(RD1, digits, sa, ALUCtrl)
begin
    case ALUCtrl is
        when "000" => resTemp <= RD1 + digits; --addunare
        when "001" => resTemp <= RD1 - digits; --scadere 
        when "010" =>   --shift left logical
            if sa = '1' then
                resTemp <= RD1(14 downto 0) & '0';
            else 
                resTemp <= RD1;
            end if;
         when "011" =>  --shift right logical
            if sa = '1' then
                resTemp <= '0' & RD1(15 downto 1);
            else
                resTemp <= RD1;
         end if;
         when "100" => resTemp <= RD1 and digits; --AND
         when "101" => resTemp <= RD1 or digits; --OR
         when "110" => resTemp <= RD1 xor digits; --XOR
         when others => resTemp <= not (RD1 xor digits); --NXOR
    end case;
end process;

process(RegDst, rd, rt)
    begin
        if RegDst = '0' then
            WriteAddress <= rt;
        else 
            WriteAddress <= rd;
        end if; 
    end process;
    
res<=resTemp;
branch<=PCnext + Ext_Imm;
end Behavioral;
