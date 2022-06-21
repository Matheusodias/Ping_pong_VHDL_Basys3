----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2018 04:53:51
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- www.dontpad.com/ped2/top_module    xdc


entity top is
    Port (reset: in std_logic; 
          clk: in std_logic; 
          player1: in std_logic;
          player2: in std_logic;
          seg: out std_logic_vector(6 downto 0);
          an: out std_logic_vector(3 downto 0);
          led : out std_logic_vector(15 downto 0));
end top;

architecture Behavioral of top is

    component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
    end component;

  component ping_pong is
  generic(             C_FAMILY : string := "7S"; 
              C_RAM_SIZE_KWORDS : integer := 1;
           C_JTAG_LOADER_ENABLE : integer := 0);
  Port (      address : in std_logic_vector(11 downto 0);
          instruction : out std_logic_vector(17 downto 0);
               enable : in std_logic;
                  rdl : out std_logic;                    
                  clk : in std_logic);
  end component;
  
  component bin7seg is
    Port ( in_deco	: in std_logic_vector(3 downto 0);
		 seg 		: out std_logic_vector(6 downto 0));
  end component;
  
  component clock_div is
	Port (	 clk 		: in STD_LOGIC;
			 my_clk		: out STD_LOGIC);
  end component;
  
  signal         address : std_logic_vector(11 downto 0);
  signal     instruction : std_logic_vector(17 downto 0);
  signal     bram_enable : std_logic;
  signal     my_clk : std_logic;
  signal         in_port : std_logic_vector(7 downto 0);
  signal        out_port : std_logic_vector(7 downto 0);
  signal         port_id : std_logic_vector(7 downto 0);
  signal         sw1 : std_logic_vector(7 downto 0);
  signal         sw2 : std_logic_vector(7 downto 0);
  signal         score1 : std_logic_vector(7 downto 0);
  signal         score2 : std_logic_vector(7 downto 0);
  signal         in_deco1 : std_logic_vector(3 downto 0);
  signal         in_deco2 : std_logic_vector(3 downto 0);
  signal         segmentos1 : std_logic_vector(6 downto 0);
  signal         segmentos2 : std_logic_vector(6 downto 0);
  signal         anodo : std_logic_vector(3 downto 0);
  signal    write_strobe : std_logic;
  signal  k_write_strobe : std_logic;
  signal     read_strobe : std_logic;
  signal       interrupt : std_logic;
  signal   interrupt_ack : std_logic;
  signal    kcpsm6_sleep : std_logic;
  signal    kcpsm6_reset : std_logic;
  
  signal       cpu_reset : std_logic;
  signal             rdl : std_logic;
  
  signal     int_request : std_logic;

begin

processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => reset,
                       clk => clk);
                       
  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;
  
    program_rom: ping_pong                  --Name to match your PSM file
    generic map(             C_FAMILY => "7S",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 1,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 0)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);
                       
sw1 <= player1 & sw1(6 downto 0);
sw2 <= sw2(7 downto 1) & player2;



decod1: bin7seg Port map(in_deco => in_deco1, seg => segmentos1);
decod2: bin7seg Port map(in_deco => in_deco2, seg => segmentos2);
divclk: clock_div Port map(clk => clk, my_clk => my_clk);

input_output_ports: process(clk)
begin
    if rising_edge(clk) then
        if port_id(7 downto 0) = "00000001" and write_strobe='1' then
            led(15 downto 8) <= out_port;
        elsif port_id(7 downto 0) = "00000010" and write_strobe='1' then
            led(7 downto 0) <= out_port; 
        elsif port_id(7 downto 0) = "00000011"   then
            in_port <= sw1;
        elsif port_id(7 downto 0) = "00000100"  then
            in_port <= sw2;
        elsif port_id(7 downto 0) = "00000101" and write_strobe='1' then
            score1 <= out_port;
        elsif port_id(7 downto 0) = "00000110" and write_strobe='1' then
            score2 <= out_port;
        end if;
    end if;
end process input_output_ports;

in_deco1 <= score2(3 downto 0);
in_deco2 <= score1(3 downto 0);

process(my_clk)
begin
    if rising_edge(my_clk) then
        if anodo = "0000" then
            anodo <= "1110";
            seg <= segmentos1;
        elsif anodo = "1110" then
            anodo <= "0111";
            seg <= segmentos2;
        elsif anodo = "0111" then
            anodo <= "1110";
            seg <= segmentos1;
        else 
            anodo <= "1110"; 
            seg <= segmentos1;
        end if;
    end if;
end process;

an <= anodo;
     
end Behavioral;







