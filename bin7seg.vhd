----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2019 22:46:08
-- Design Name: 
-- Module Name: bin7seg - Behavioral
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

entity bin7seg is
Port ( in_deco	: in std_logic_vector(3 downto 0);
		 seg 		: out std_logic_vector(6 downto 0));
end bin7seg;

architecture Behavioral of bin7seg is

begin

	-- decodificador bin to 7 seg
	process(in_deco)
	begin
		case in_deco is
			when "0000" => seg <= "1000000";
			when "0001" => seg <= "1111001";
			when "0010" => seg <= "0100100";
			when "0011" => seg <= "0110000";
			when "0100" => seg <= "0011001";
			when "0101" => seg <= "0010010";
			when "0110" => seg <= "0000010";
			when "0111" => seg <= "1111000";
			when "1000" => seg <= "0000000";
			when "1001" => seg <= "0010000";
			when "1010" => seg <= "0001000";
			when "1011" => seg <= "0000011";
			when "1100" => seg <= "1000110";
			when "1101" => seg <= "0100001";
			when "1110" => seg <= "0000110";
			when "1111" => seg <= "0001110";
			when others => seg <= "1111111";
		end case;
	end process;

end Behavioral;
