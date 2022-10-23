----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 04:17:07 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
Port (aluRes : in std_logic_vector(15 downto 0);
         RD2 : in std_logic_vector(15 downto 0);
       memWrite : in std_logic;
       clk : in std_logic;
       enable : in std_logic;
        memdata : out std_logic_vector (15 downto 0)
        );
end MEM;

architecture Behavioral of MEM is

type type_RAM is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal mem: type_RAM:= (
X"0000", 
X"0001",
others => X"0000" 
);
begin

process(clk)
begin
    if(clk'event and clk = '1') then
        if enable = '1' then 
            if(MemWrite = '1') then
                mem(conv_integer(aluRes(3 downto 0))) <= RD2;
            end if; 
        end if;
    end if;
end process;

MemData <= mem(conv_integer(ALUres(3 downto 0)));

end Behavioral;
