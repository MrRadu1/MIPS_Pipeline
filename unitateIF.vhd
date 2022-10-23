----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2022 04:21:57 PM
-- Design Name: 
-- Module Name: UnitateIF - Behavioral
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

entity unitateIF is
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
end unitateIF;

architecture Behavioral of unitateIF is
signal D : std_logic_vector(15 downto 0);
signal addd: std_logic_vector(15 downto 0);
signal Q : std_logic_vector(15 downto 0);
signal digits : std_logic_vector(15 downto 0);
signal outRom : std_logic_vector(15 downto 0);
type rom_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal ROM: rom_type := (
    B"000_000_000_000_0_110",--0: XOR $0, $0 , $0 0006  
    B"000_001_001_001_0_110",--1: XOR $1, $1 , $1 0496
    B"000_010_010_010_0_110",--2: XOR $2, $2 , $2 0926
    B"000_011_011_011_0_110",--3: XOR $3, $3 , $3 0db6
    B"000_100_100_100_0_110",--4: XOR $4, $4 , $4 1246
    B"000_101_000_000_0_000",--5: ADD $0, $0, $5 1400
    B"001_011_011_0000010",--6: ADDI $3, $3, 2 2d82
    B"000_001_001_001_0_000", --NOP 
    B"000_001_001_001_0_000", --NOP 
    B"000_011_010_010_0_000",--7: ADD $2, $2, $3 0d20
    B"001_100_100_0000001", --8: ADDI $4, $4, 1 3201
    B"000_001_001_001_0_000", --NOP 
                                
    B"000_001_001_001_0_000", --NOP 
    B"100_100_000_0000100",--9: BEQ $0, $4, 4 9001
    B"000_001_001_001_0_000", --NOP 
    B"000_001_001_001_0_000", --NOP 
    B"000_001_001_001_0_000", --NOP 
    B"111_0000000000110", --10: J6 E006
    B"000_001_001_001_0_000", --NOP 
    B"011_001_010_0000000", --11: SW $2, 0($1) 6500
    B"010_001_010_0000000", --12: LW $2, 0($1) 4500
    others => B"0000000000000000" 
    );

begin 
process(clk)
begin
    if rising_edge(clk) then
        if memReset = '1' then
            Q <= X"0000";
        elsif enablePC= '1' then
            Q <= D;
        end if;
 end if;
end process;

process(branchAddr,  pcSrc, addd)
    begin
        case pcSrc is
        when '0'    => digits <= addd;
        when others => digits <=  branchAddr;
        end case;
        end process;

process(jumpAddr,  jump, digits)
    begin
        case jump is
        when '0'    => D <= digits;
        when others => D <= jumpAddr;
        end case;
        end process;
        
        
addd<=Q+1;
outPC<=addd;
instruction<=Rom(conv_integer(Q));
end Behavioral;
