NB. =========================================================
NB.*chopcsv v Box delimited fields in string
NB. form: [fd[,sd0[,sd1]]] chopcsv string
NB. returns: list of boxed literals
NB. y is: delimited string
NB. x is: optional delimiters. Default is ',""'
NB.       0{ field delimiter (fd)
NB.       1{ (start) string delimiter (sd0)
NB.       2{ end string delimiter (sd1)
chopcsv=: 3 : 0
  ',""' chopcsv y
  :
  dat=. y
  assert. (0<#x), 0=L.x
  if. 1=#x do. sd=. '""'
  else. sd=. 2$}.x end.
  fd=. {.x
  if. =/sd do. sd=. {.sd
  else. NB. replace diff start and end delims with single
    s=. {.('|'=fd){ '|`'  NB. choose single sd
    dat=. dat rplc ({.sd);s;({:sd);s
    sd=. s
  end.
  dat=. dat,fd
  b=. dat = fd
  c=. dat = sd
  d=. ~:/\ c                       NB. mask inside sds
  fmsk=. b > d                     NB. end of fields
  smsk=. (> (0 , }:)) c            NB. first in group of sds
  smsk=. -. smsk +. c *. 1|.fmsk   NB. or previous to fd
  dat=. smsk#dat  NB. compress out string delims
  fmsk=. smsk#fmsk
  fmsk <;._2 dat  NB. box
)

NB. =========================================================
NB.*fixcsv v Convert csv data into J array
NB. form: [fd[,sd0[,sd1]]] fixcsv dat
NB. returns: array of boxed literals
NB. y is: delimited string
NB. x is: optional delimiters. Default is ',""'
NB.       0{ field delimiter (fd)
NB.       1{ (start) string delimiter (sd0)
NB.       2{ end string delimiter (sd1)
fixcsv=: 3 : 0
  ',' fixcsv y
  :
  if. 1=#x do. sd=. '""'
  else. sd=. 2$}.x end.
  if. =/sd do.
    x=. x,{.sd
  else.
    s=. {.('|'={.x){ '|`'  NB. choose single sd
    y=. y rplc ({.sd);s;({:sd);s
    x=. x,s
  end.
  b=. y e. LF
  c=. ~:/\y=1{x
  msk=. b > c
  > msk <@(x&chopcsv) ;._2 y
)

NB. =========================================================
NB.*readcsv v Reads csv file into a boxed array
NB. form: [fd[,sd0[,sd1]]] readcsv file
NB. returns: array of boxed literals
NB. y is: filename of file to read from
NB. x is: optional delimiters. Default is ',""'
NB.       0{ field delimiter (fd)
NB.       1{ (start) string delimiter (sd0)
NB.       2{ end string delimiter (sd1)
readcsv=: 3 : 0
  ',' readcsv y
  :
  dat=. freads extcsv y
  if. dat -: _1 do. return. end.
  x fixcsv dat
)
