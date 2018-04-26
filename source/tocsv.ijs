NB. =========================================================
NB. Converting from J array to csv files/strings

NB. ---------------------------------------------------------
NB.*appendcsv v Appends an array to a csv file
NB. returns: number of bytes appended or _1 if unsuccessful
NB. form: dat appendcsv file[;fd[;sd0[,sd1]]]
NB. eg: (3 2$'hello world';4;84.3;'Big dig') appendcsv jpath '~temp/test.csv'
NB. y is: filename of file to write dat to
NB. x is: a J array
appendcsv=: 4 : 0
  x appenddsv (extcsv y);',';'""'
)

NB. ---------------------------------------------------------
NB.*makecsv v Makes a CSV string from an array
NB. returns: CSV string
NB. form: makecsv array
NB. eg: makecsv  3 2$'hello world';4;84.3;'Big dig'
NB. y is: an array
NB. Arrays are flattened to a max rank of 2.
makecsv=: (',';'""')&makedsv

NB. ---------------------------------------------------------
NB.*writecsv v Writes an array to a csv file
NB. returns: number of bytes written (_1 if write error)
NB.          An existing file will be written over.
NB. form: dat writecsv file
NB. eg: (i.2 3 4) writecsv jpath ~temp/test
NB. y is: filename of file to write dat to
NB. x is: an array to write as csv
writecsv=: 4 : 0
  x writedsv (extcsv y);',';'""'
)
