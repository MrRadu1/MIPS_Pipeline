----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2022 07:38:21 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
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
end UC;

architecture Behavioral of UC is

signal signal_RegDst : STD_LOGIC := '0';
signal signal_ExtOp : STD_LOGIC := '0';
signal signal_ALUsrc : STD_LOGIC := '0';
signal signal_Branch : STD_LOGIC := '0';
signal signal_Jump : STD_LOGIC := '0';
signal signal_ALUop : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal signal_MemWrite : STD_LOGIC := '0';
signal signal_MemToReg : STD_LOGIC := '0';
signal signal_RegWrite : STD_LOGIC := '0';

begin
process(OpCode)
begin 
signal_RegDst <= '0';
signal_ExtOp <= '0';
signal_ALUsrc <= '0';
signal_Branch <= '0';
signal_Jump <= '0';
signal_ALUop <= (others => '0');
signal_MemWrite <= '0';
signal_MemToReg <= '0';
signal_RegWrite <= '0';
case OpCode is 
    when "000" => --tip  R
         signal_RegDst <= '1';
         signal_RegWrite <= '1';
    when "001" => -- ADDI
         signal_RegWrite <= '1';
         signal_ALUsrc <= '1';
         signal_ExtOp <= '1';
         signal_ALUop <= "01";
    when "010" => --LW
         signal_RegWrite <= '1';
         signal_ALUsrc <= '1';
         signal_ExtOp <= '1';
         signal_MemToReg <= '1';
         signal_ALUop <= "01";
    when "011" => --SW
         signal_ALUsrc <= '1';
         signal_ExtOp <= '1';
         signal_MemWrite <= '1';
         signal_ALUop <= "01";
    when "100" => --beq
         signal_ExtOp <= '1';
         signal_Branch <= '1';
          signal_ALUop <= "10";
    when "101" => --ori
         signal_ALUsrc <= '1';
         signal_RegWrite <= '1';
         signal_ALUop <= "11";
    when "110" =>  --subi
         signal_RegWrite <= '1';
             signal_ALUsrc <= '1';
             signal_ExtOp <= '1';
             signal_ALUop <= "10";
    when others =>
         signal_Jump <= '1';
 end case;
 end process;
 
 RegDst <= signal_RegDst;
 ExtOp <= signal_ExtOp;
 ALUsrc <= signal_ALUsrc;
 Branch <= signal_Branch;
 Jump <= signal_Jump;
 ALUop <= signal_ALUop;
 MemWrite <= signal_MemWrite;
 MemToReg <= signal_MemToReg;
 RegWrite <= signal_RegWrite;

end Behavioral;

