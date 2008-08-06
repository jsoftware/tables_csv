NB. test
buildproject_jproject_ ''
load TARGETFILE_jproject_
tstpth=. PATHSEP_j_ dropto &.|. TESTFILE_jproject_
open tstpth,'test.ijs'
load tstpth,'test.ijs'
test ''
