NB. =========================================================
NB.*chopcsv v Box delimited fields in string
NB. form: [fd[;sd0[,sd1]]] chopcsv string
NB. returns: list of boxed literals
NB. y is: delimited string
NB. x is: literal or 1 or 2-item boxed list of optional delimiters.
NB.       0{:: single literal field delimiter (fd). Defaults to ','
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. eg: ('|';'<>') chopcsv '<hello world>|4|84.3'
chopcsv=: 3 : 0
  (',';'""') chopcsv y
  :
  dat=. y
  x=. boxopen x
  if. 1=#x do. x=. x,<'""' end.
  'fd sd'=. 2{.x
  assert. 1 = #fd
  if. =/sd do. sd=. (-<:#sd)}.sd   NB. empty, one or two same
  else. NB. replace diff start and end delims with single
    s=. {.('|'=fd){ '|`'  NB. choose single sd
    dat=. dat rplc ({.sd);s;({:sd);s
    sd=. s
  end.
  dat=. dat,fd
  b=. dat e. fd
  c=. dat e. sd
  d=. ~:/\ c                       NB. mask inside sds
  fmsk=. b > d                     NB. end of fields
  smsk=. (> (0 , }:)) c            NB. first in group of sds
  smsk=. -. smsk +. c *. 1|.fmsk   NB. or previous to fd
  y=. smsk#y,fd   NB. compress out string delims
  fmsk=. smsk#fmsk
  fmsk <;._2 y  NB. box
)

NB. =========================================================
NB.*fixcsv v Convert csv data into J array
NB. form: [fd[;sd0[,sd1]]] fixcsv dat
NB. returns: array of boxed literals
NB. y is: delimited string
NB. x is: literal or 1 or 2-item boxed list of optional delimiters.
NB.       0{:: field delimiter (fd). Defaults to ','
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. eg: ('|';'<>') fixcsv '<hello world>|4|84.3',LF,'<Big dig>|<hello world>|4',LF
fixcsv=: 3 : 0
  (',';'""') fixcsv y
  :
  dat=. y
  x=. boxopen x
  if. 1=#x do. x=. x,<'""' end.
  'fd sd'=. 2{.x
  if. =/sd do. sd=. (-<:#sd)}.sd   NB. empty, one or two same
  else.
    s=. {.('|'=fd){ '|`'  NB. choose single sd
    dat=. dat rplc ({.sd);s;({:sd);s
    sd=. s
  end.
  b=. dat e. LF
  c=. ~:/\ dat e. sd
  msk=. b > c
  > msk <@(x&chopcsv) ;._2 y
)

NB. =========================================================
NB.*readcsv v Reads csv file into a boxed array
NB. form: [fd[;sd0[,sd1]]] readcsv file
NB. returns: array of boxed literals
NB. y is: filename of file to read from
NB. x is: literal or 1- or 2-item boxed list of optional delimiters.
NB.       0{:: field delimiter (fd). Defaults to ','
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. eg: ('|';'<>') readcsv jpath '~temp/test.csv'
readcsv=: 3 : 0
  (',';'""') readcsv y
  :
  dat=. freads extcsv y
  if. dat -: _1 do. return. end.
  x fixcsv dat
)
