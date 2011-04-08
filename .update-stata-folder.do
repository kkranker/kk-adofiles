*! .update-stata-folder.do
*! Publish Keith's stata files to http://code.google.com/p/kk-adofiles/

cd "C:\Projects\code.google.com\kk-adofiles\"

pub2web ///
	alt ///
	areastack ///
	beep ///
/*	bootstrap_exit_early */ /// 
	byxtline ///
/*	case_predict (manually add to txtvarlist) */  /// 
	clean_row_vector ///
/* 	csvvars (manually add to txtvarlist) */  /// 
	deadline ///
	dhs_cmc ///
	did3 /// 
	dropstringvars /// 
	e_ ///
	etcalconvert ///
	exceldesc /// 
	foldercodebook /// 
	foldergraphexport /// 
	getcmds_personal ///
/*	glm_linear_test */  /// 
	graphbetas ///
	kak_ ///
	margfx2 ///
	mat2txt2 /// 
	mat_blockdiag ///
	meantab /// 
	memmax /// 
	motionchart /// 
	moveb ///
	normdiff /// 
	npp ///
	predict_toggle ///
	predlog2 /// 
	pub2web ///
	scatter_hist /// 
/*	tpm_xtgee_mfx */  /// 
	txt2notes /// 
	txtvarlist /// 
	usedrop /// 
	varlist_type ///
	xilabel /// 
	xtdesc ///
	, replace author( "Keith Kranker") ///
	intro( "Programs by Keith Kranker, Ph.D. Candidate, Department of Economics, University of Maryland")

view net from "`c(pwd)'"

// add csvvars to txtvarlist package
local addtopackage
file open  addp using txtvarlist.pkg , write append
file write addp _newline 
foreach file in "c/csvvars.ado" "c/csvvars.hlp" {
	copy "C:/Ado/personal/`file'"  "`c(pwd)'/`file'", replace
	file write addp "f `file'" _newline 
}
file close addp

// add case_predict to predict_toggle package
local addtopackage
file open  addp using predict_toggle.pkg , write append
file write addp _newline 
foreach file in "c/case_predict.ado" "c/case_predict.hlp" {
	copy "C:/Ado/personal/`file'"  "`c(pwd)'/`file'", replace
	file write addp "f `file'" _newline 
}
file close addp

