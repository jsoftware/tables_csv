NB. =========================================================
NB. extcsv v adds '.csv' extension if none present
extcsv=: , #&'.csv' @ (0: = '.'"_ e. (# | i:&PATHSEP_j_) }. ])

NB. =========================================================
NB.*quote v Encloses string in quotes
NB. form: [sd0[,sd1]] quote strng(s)
NB. returns: quoted string
NB. y is: string or boxed strings to quote
NB. x is: optional quote type. Default is ''''''
NB.       0{ is (start) string delimiter (sd0)
NB.       1{ is end string delimiter (sd1)
NB. Internal quotes are doubled if required.
quote=: 3 : 0
  '''''' quote y
  :
  if. 0<L. y do. x&quote &.> y return. end.
  if. -.(#x)e. 0 2 do. x=. 2$x end.
  (}:x),((>: (y e. x) *. =/x)#y),}.x
)

NB. =========================================================
NB.*makenum v Converts cells in array of boxed literals to numeric where possible
NB. form: [err] makenum array
NB. returns: numeric array or array of boxed literals and numbers
NB. y is: an array of boxed literals
NB. x is: optional numeric error code. Default is _9999
makenum=: 3 : 0
  _9999 makenum y
  :
  dat=. , x&". &.> y=. boxopen y
  idx=. I. x&e.@> dat
  if. #idx do.
    dat=. (idx{,y) idx}dat NB. amend non-numeric cells
  else.
    dat=. >dat NB. unbox to list if all numeric
  end.
  ($y)$dat
)

NB. =========================================================
NB.*makenumcol v Converts columns in table of boxed literals to numeric where possible
NB. form: [err] makenumcol array
NB. returns: numeric array or array of boxed literal and numeric columns
NB. y is: an array of boxed literals
NB. x is: optional numeric error code. Default is _9999
NB. Only converts column to numeric if conversion is possible for whole column
makenumcol=: 3 : 0
  _9999 makenumcol y
  :
  dat=. x&". &.> y=. boxopen y
  notnum=. x&e.@> dat NB. mask of boxes containing error code
  idx=. I. +./notnum  NB. index of non-numeric columns
  if. #idx do.
    dat=. (idx{"1 y) (<a:;idx)}dat NB. amend non-numeric columns
  else.
    dat=. >dat NB. unbox to list if all numeric
  end.
)
