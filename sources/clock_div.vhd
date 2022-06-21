----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2019 21:42:29
-- Design Name: 
-- Module Name: clock_div - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div is
	Port (	 clk 		: in STD_LOGIC;
			 my_clk		: out STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is

--signal count : unsigned(22 downto 0) := (others=>'0');
signal count : integer range 0 to 500000 := 0; 
signal auxled : std_logic := '0';

begin

	-- contador de 100 ms e criacao do enable
	process(clk)
	begin
		
		if rising_edge(clk) then
			if count = 500000 then 
				auxled <= not auxled;
				count <= 0;
			else
				count <= count+1;
			end if;
		end if;
	end process;
    
	my_clk <= auxled;
    
end Behavioral;
