-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\detector\adderEnergy.vhd
-- Created: 2022-09-01 15:45:31
-- 
-- Generated by MATLAB 9.12 and HDL Coder 3.20
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: adderEnergy
-- Source Path: detector/detector/adderEnergy
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.detector_pkg.ALL;

ENTITY adderEnergy IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        sequence                          :   IN    vector_of_std_logic_vector25(0 TO 7);  -- sfix25 [8]
        sumVal                            :   OUT   std_logic_vector(27 DOWNTO 0)  -- sfix28
        );
END adderEnergy;


ARCHITECTURE rtl OF adderEnergy IS

  -- Signals
  SIGNAL sequence_signed                  : vector_of_signed25(0 TO 7);  -- sfix25 [8]
  SIGNAL sumVal_tmp                       : signed(27 DOWNTO 0);  -- sfix28
  SIGNAL sumVal_reg                       : signed(27 DOWNTO 0);  -- sfix28
  SIGNAL level2                           : vector_of_signed27(0 TO 1);  -- sfix27 [2]
  SIGNAL level1                           : vector_of_signed26(0 TO 3);  -- sfix26 [4]
  SIGNAL sumVal_reg_next                  : signed(27 DOWNTO 0);  -- sfix28
  SIGNAL level2_next                      : vector_of_signed27(0 TO 1);  -- sfix27 [2]
  SIGNAL level1_next                      : vector_of_signed26(0 TO 3);  -- sfix26 [4]

BEGIN
  outputgen: FOR k IN 0 TO 7 GENERATE
    sequence_signed(k) <= signed(sequence(k));
  END GENERATE;

  adderEnergy_1_process : PROCESS (clk, reset)
    VARIABLE t_2 : INTEGER;
    VARIABLE t_3 : INTEGER;
  BEGIN
    IF reset = '0' THEN
      sumVal_reg <= to_signed(16#0000000#, 28);

      FOR t_2 IN 0 TO 1 LOOP
        level2(t_2) <= to_signed(16#0000000#, 27);
      END LOOP;


      FOR t_3 IN 0 TO 3 LOOP
        level1(t_3) <= to_signed(16#0000000#, 26);
      END LOOP;

    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        sumVal_reg <= sumVal_reg_next;

        FOR t_0 IN 0 TO 1 LOOP
          level2(t_0) <= level2_next(t_0);
        END LOOP;


        FOR t_1 IN 0 TO 3 LOOP
          level1(t_1) <= level1_next(t_1);
        END LOOP;

      END IF;
    END IF;
  END PROCESS adderEnergy_1_process;

  adderEnergy_1_output : PROCESS (level1, level2, sequence_signed, sumVal_reg)
    VARIABLE add_temp : signed(28 DOWNTO 0);
    VARIABLE cast : vector_of_signed64(0 TO 1);
    VARIABLE add_cast : vector_of_signed64(0 TO 1);
    VARIABLE cast_0 : vector_of_signed64(0 TO 3);
    VARIABLE add_cast_0 : vector_of_signed64(0 TO 3);
  BEGIN

    FOR t_0 IN 0 TO 3 LOOP
      level1_next(t_0) <= level1(t_0);
    END LOOP;

    --    %% Registers
    --    %% Set outputs
    --    %% Update registersa
    add_temp := resize(level2(0), 29) + resize(level2(1), 29);
    sumVal_reg_next <= add_temp(27 DOWNTO 0);

    FOR i IN 0 TO 1 LOOP
      cast(i) := resize(to_signed(i, 32) & '0', 64);
      add_cast(i) := resize(to_signed(i, 32) & '0', 64);
      level2_next(i) <= resize(level1(to_integer(resize(cast(i), 31))), 27) + resize(level1(to_integer(resize(add_cast(i), 32) + 1)), 27);
    END LOOP;


    FOR i_0 IN 0 TO 3 LOOP
      cast_0(i_0) := resize(to_signed(i_0, 32) & '0', 64);
      add_cast_0(i_0) := resize(to_signed(i_0, 32) & '0', 64);
      level1_next(i_0) <= resize(sequence_signed(to_integer(resize(cast_0(i_0), 31))), 26) + resize(sequence_signed(to_integer(resize(add_cast_0(i_0), 32) + 1)), 26);
    END LOOP;

    sumVal_tmp <= sumVal_reg;
  END PROCESS adderEnergy_1_output;


  sumVal <= std_logic_vector(sumVal_tmp);

END rtl;
