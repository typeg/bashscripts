# find files under ~/logs which name contains 2018-10-15 except jpa 
tail -f tail -f `find ~/logs -name "*2018-10-15*" \! -name "jpa*"`