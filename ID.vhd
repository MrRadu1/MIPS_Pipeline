----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2022 06:18:09 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
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
end ID;

architecture Behavioral of ID is

type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (X"0000", 
X"0001",
X"0002",
X"0003",
X"0004",
X"0005",
X"0006",
others => X"0000");

begin
process(clk)
begin
    if falling_edge(clk) then
        if enable = '1' then
            if regWrite = '1' then
                reg_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end if;
end process;
rd1 <= reg_file(conv_integer(instr(12 downto 10)));
rd2 <= reg_file(conv_integer(instr(9 downto 7)));

--process(regDst,instr)
--    begin
--        case regDst is
--        when '0'    => wa <= instr(9 downto 7);
--        when others => wa <=  instr(6 downto 4);
--        end case;
--        end process;
        
with ext_op select
           ext_Imm(15 downto 7) <= (others => instr(6)) when '1', 
               (others => '0') when others;  

ext_Imm(6 downto 0) <= instr(6 downto 0);
sa <= instr(3);
func <= instr(2 downto 0);
rt <= instr(9 downto 7);
rd <= instr(6 downto 4);
end Behavioral;
