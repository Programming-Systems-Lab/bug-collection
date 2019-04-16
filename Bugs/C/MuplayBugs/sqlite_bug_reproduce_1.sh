cd sqlite-buggy-1-obj
cp ../test.db ./
./sqlite3 test.db 'INSERT INTO t1 SELECT * FROM t2';
