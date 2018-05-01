NB. build

writesource_jp_ '~Addons/tables/csv/source';'~Addons/tables/csv/csv.ijs'

(jpath '~addons/tables/csv/csv.ijs') (fcopynew ::0:) jpath '~Addons/tables/csv/csv.ijs'

f=. 3 : 0
(jpath '~Addons/tables/csv/',y) fcopynew jpath '~Addons/tables/csv/source/',y
(jpath '~addons/tables/csv/',y) (fcopynew ::0:) jpath '~Addons/tables/csv/source/',y
)

mkdir_j_ jpath '~addons/tables/csv'
f 'manifest.ijs'
f 'history.txt'
f 'test/test_csv.ijs'
