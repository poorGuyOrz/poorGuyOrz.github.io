SELECT 
    procpid, 
    start, 
    now() - start AS lap, 
    current_query 
FROM 
    (SELECT 
        backendid, 
        pg_stat_get_backend_pid(S.backendid) AS procpid, 
        pg_stat_get_backend_activity_start(S.backendid) AS start, 
       pg_stat_get_backend_activity(S.backendid) AS current_query 
    FROM 
        (SELECT pg_stat_get_backend_idset() AS backendid) AS S 
    ) AS S 
WHERE 
   current_query <> '<IDLE>' 
ORDER BY 
   lap DESC;





../configure --prefix=/home/wen/postgres/build/antdb/build --with-segsize=4 --with-wal-blocksize=64 --enable-grammar-oracle --with-perl --with-python --with-pam --with-ldap --with-libxml --with-libxslt --enable-thread-safety --disable-debug --disable-cassert --enable-depend CFLAGS='-g'


select pg_backend_pid()


pgxc_handle_unsupported_stmts