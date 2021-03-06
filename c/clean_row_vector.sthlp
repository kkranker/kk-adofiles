*! $Id$

Help for clean_row_vector.ado

Drop empty cells from a row vector, while keeping column labels

written for and required by  tpm_xtgee_mfx.ado

By Keith Kranker
$Date$

 example: 
   mat test = (.,12.2,4,.,.,5,0,.)
   mat colnames test = eq1:var0 eq1:var1 eq1:var2 eq1:var3 var1 var2 eq2:var1 eq2:var2 
   clean_row_vector test , noisily s(test2)
   clean_row_vector test , noisily

  syntax name(name=mat) [, Save(name) Noisily]  
