*! $Id: personal/m/mat_blockdiag.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Combine to diagonal matrices into a single matrix (preserves row/column names)
*!
*! By Keith Kranker
*! $Date$

// syntax: 
// . mat_blockdiag  new_matrix_name  =  matrix_name_1  matrix_name_2

// based on the command
// . mata: st_matrix( "newmat", blockdiag( st_matrix( "mat1"), st_matrix( "mat2")))
// execpt that it preserves row/column names

program define mat_blockdiag 
  version 9.2
  syntax anything(equalok) [, gen list]
  gettoken newmat anything : anything , parse( "=" ) bind
  gettoken equals anything : anything , parse( "=" ) bind
  gettoken mat1   mat2     : anything , parse( " " ) bind

  if !missing("`gen'") {
		tempname gen1 gen2
		mat `gen1' = `mat1'
		mat `gen2' = `mat2'  
		local mat1 "`gen1'"
		local mat2 "`gen2'"
  }
  local newmat_colnames `:colfullnames `mat1'' `:colfullnames `mat2''
  local newmat_rownames `:rowfullnames `mat1'' `:rowfullnames `mat2''
  mata: st_matrix( "`newmat'", blockdiag( st_matrix( "`mat1'"), st_matrix( "`mat2'")))
  matrix colnames `newmat' = `newmat_colnames'
  matrix rownames `newmat' = `newmat_rownames'
  if !missing("`list'") mat list `newmat'
end 
