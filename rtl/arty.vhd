library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arty is port (
	clk : in std_logic;
	led : out std_logic := '0');
end arty;

architecture behav of arty is
	signal count : unsigned(31 downto 0) := (others => '0');
begin
	process(clk)
	begin
		if rising_edge(clk) then
			count <= count + 1;
			if and count then
				led <= not led;
			end if;
		end if;
	end process;
end behav;
