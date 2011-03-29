*! $Id: personal/c/clean_row_vector.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Drop empty cells from a row vector (matrix), while keeping column labels
*
*! By Keith Kranker
*! $Date$

// written for and required by  tpm_xtgee_mfx.ado

/* 
example: 
  mat test = (.,12.2,4,.,.,5,0,.)
  mat colnames test = eq1:var0 eq1:var1 eq1:var2 eq1:var3 var1 var2 eq2:var1 eq2:var2 
  clean_row_vector test , noisily s(test2)
  clean_row_vector test , noisily
*/

  
program define clean_row_vector

  syntax name(name=mat) [, Save(name) Noisily]  
  if 1 != `=rowsof(`mat')'  {
    di as error "`mat' is not a row vector (1 x C matrix)"
    cap mat list `mat'
    error 
  }
    
  if !missing("`noisily'") mat list `mat'

  if !missing("`save'") {
  local dest `save'
  mat `dest' = `mat'
  }
  else local dest `mat'
  
  local c=1
  while `c' <= `=colsof(`dest')' {
    if !missing(`dest'[1,`c']) local ++c
    else {
      if (`c'==`=colsof(`dest')') mat `dest' = `dest'[1,1..`=colsof(`dest')-1'] 
      else if (`c'==1)            mat `dest' = `dest'[1,2..`=colsof(`dest')'] 
      else                        mat `dest' = ( `dest'[1,1..`=`c'-1'] , `dest'[1,`=`c'+1'..`=colsof(`dest')']  )
    }
  }
 
   if !missing("`noisily'") mat list `dest'

end
  
