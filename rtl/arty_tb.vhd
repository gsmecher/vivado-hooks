library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

entity arty_tb is
end arty_tb;

architecture behav of arty_tb is
	signal clk : std_logic := '0';
	signal led : std_logic;
begin
	clk <= not clk after 5 ns;

	dut : entity work.arty
	port map (
		clk => clk,
		led => led);

	stim_proc : process
	begin
		wait for 100 ns; -- whatever
		finish(0);
	end process;
end behav;
