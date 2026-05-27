------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 05/26/2026 04:29:26 PM
---- Design Name: 
---- Module Name: mkv_top - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
--  Top module có handshake:
--  INPUT SIDE
--  ----------
--  i_ready = '1' : he thong da chuan bi du input san sang nap valid
--  i_valid = '1' : cho phep nap input vao core -> i_ready = '0'

--  OUTPUT SIDE
--  -----------
--  o_ready = '1' : ket qua da san sang
--  o_valid = '1' : cho phep xuat output -> o_ready = '0'
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mkv_top is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- INPUT HANDSHAKE
        i_valid     : in  std_logic;
        i_ready     : out std_logic;

        -- MODE
        i_mode      : in  std_logic;

        -- OUTPUT HANDSHAKE
        o_valid     : in  std_logic;
        o_ready     : out std_logic;

        -- DATA
        key_master  : in  std_logic_vector(255 downto 0);
        data_in     : in  std_logic_vector(127 downto 0);

        data_out    : out std_logic_vector(127 downto 0)
    );
end mkv_top;

architecture Behavioral of mkv_top is

    component encrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;

            key_master  : in  std_logic_vector(255 downto 0);
            plaintext   : in  std_logic_vector(127 downto 0);

            done        : out std_logic;
            ciphertext  : out std_logic_vector(127 downto 0)
        );
    end component;

    component decrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;

            key_master  : in  std_logic_vector(255 downto 0);
            ciphertext  : in  std_logic_vector(127 downto 0);

            done        : out std_logic;
            plaintext   : out std_logic_vector(127 downto 0)
        );
    end component;

    signal enc_start    : std_logic := '0';
    signal dec_start    : std_logic := '0';

    signal enc_done     : std_logic;
    signal dec_done     : std_logic;

    signal enc_data     : std_logic_vector(127 downto 0);
    signal dec_data     : std_logic_vector(127 downto 0);
    signal data_out_reg : std_logic_vector(127 downto 0);
    type state_type is (
        IDLE_WAIT_INPUT,
        IDLE_WAIT_VALID,
        RUNNING,
        OUTPUT_WAIT,
        WRITE_DATAOUT
    );
    signal state : state_type := IDLE_WAIT_INPUT;
    constant ZERO256 : std_logic_vector(255 downto 0) := (others => '0');
    constant ZERO128 : std_logic_vector(127 downto 0) := (others => '0');
begin
    ENC_CORE : encrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => enc_start,

        key_master  => key_master,
        plaintext   => data_in,

        done        => enc_done,
        ciphertext  => enc_data
    );
    DEC_CORE : decrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => dec_start,

        key_master  => key_master,
        ciphertext  => data_in,

        done        => dec_done,
        plaintext   => dec_data
    );
    process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE_WAIT_INPUT;
            enc_start <= '0';
            dec_start <= '0';
            i_ready <= '0';
            o_ready <= '0';
            data_out <= (others => '0');
            data_out_reg <= (others => '0');
        elsif rising_edge(clk) then
            enc_start <= '0';
            dec_start <= '0';
            case state is
                when IDLE_WAIT_INPUT =>
                    o_ready <= '0';
                    if (key_master /= ZERO256) and (data_in /= ZERO128) then                    
                        i_ready <= '1';
                        state <= IDLE_WAIT_VALID;
                    else
                        i_ready <= '0';
                    end if;
                when IDLE_WAIT_VALID =>                    
                    if i_valid = '1' then
                        i_ready <= '0';
                        if i_mode = '1' then
                            enc_start <= '1';
                        else
                            dec_start <= '1';
                        end if;
                        state <= RUNNING;
                    end if;
                when RUNNING =>
                    if enc_done = '1' then
                        data_out_reg <= enc_data;
                        o_ready <= '1';
                        state <= OUTPUT_WAIT;
                    elsif dec_done = '1' then
                        data_out_reg <= dec_data;
                        o_ready <= '1';
                        state <= OUTPUT_WAIT;
                    end if;
                when OUTPUT_WAIT =>
                    if o_valid = '1' then
                        o_ready <= '0';
                        data_out <= data_out_reg;                        
                        state <= WRITE_DATAOUT;                        
                    end if;
                when WRITE_DATAOUT =>
                    if o_valid = '0' then
                        state <= IDLE_WAIT_INPUT;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;