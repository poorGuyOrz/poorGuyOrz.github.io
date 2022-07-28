make: Entering directory '/home/wen/postgres-home/postgres-xc/src/backend/parser'
gcc -DPGXC -g -Wall -Wmissing-prototypes -Wpointer-arith -Wdeclaration-after-statement -Wendif-labels -Wmissing-format-attribute -Wformat-security -fno-strict-aliasing -fwrapv -fexcess-precision=standard -Wno-error -I. -I. -I../../../src/include -D_GNU_SOURCE   -c -o gram.o gram.c


gcc -Wall -Wmissing-prototypes -Wpointer-arith -Wdeclaration-after-statement -Werror=vla -Wendif-labels -Wmissing-format-attribute -Wimplicit-fallthrough=3 -Wcast-function-type -Wformat-security -fno-strict-aliasing -fwrapv -fexcess-precision=standard -Wno-format-truncation -Wno-stringop-truncation -g -I. -I. -I../../../src/include  -D_GNU_SOURCE   -c -o gram.o gram.c



gcc -DPGXC  -Wall -Wmissing-prototypes -Wpointer-arith -Wdeclaration-after-statement -Werror=vla -Wendif-labels -Wmissing-format-attribute -Wimplicit-fallthrough=3 -Wcast-function-type -Wformat-security -fno-strict-aliasing -fwrapv -fexcess-precision=standard -Wno-format-truncation -Wno-stringop-truncation -g -I. -I. -I../../../src/include  -D_GNU_SOURCE   -c -o gram.o gram.c
gram.y: In function ‘base_yyparse’:
gram.y:9025:11: warning: implicit declaration of function ‘superuser’ [-Wimplicit-function-declaration]
 9025 |      if (!superuser())
      |           ^~~~~~~~~
scan.c: At top level:
gram.c:68:25: error: conflicting types for ‘base_yylex’
   68 | #define yylex           base_yylex
      |                         ^~~~~~~~~~
scan.c:9108:12: note: in expansion of macro ‘yylex’
 9108 | extern int yylex \
      |            ^~~~~
In file included from gram.y:60:
../../../src/include/parser/gramparse.h:66:12: note: previous declaration of ‘base_yylex’ was here
   66 | extern int base_yylex(YYSTYPE *lvalp, YYLTYPE *llocp,
      |            ^~~~~~~~~~
gram.c:68:25: error: conflicting types for ‘base_yylex’
   68 | #define yylex           base_yylex
      |                         ^~~~~~~~~~
scan.c:9111:21: note: in expansion of macro ‘yylex’
 9111 | #define YY_DECL int yylex \
      |                     ^~~~~
scan.c:9132:1: note: in expansion of macro ‘YY_DECL’
 9132 | YY_DECL
      | ^~~~~~~
In file included from gram.y:60:
../../../src/include/parser/gramparse.h:66:12: note: previous declaration of ‘base_yylex’ was here
   66 | extern int base_yylex(YYSTYPE *lvalp, YYLTYPE *llocp,
      |            ^~~~~~~~~~





./initdb -D $PGHOME/data/db_1/data --nodename db_1
./initdb -D $PGHOME/data/db_2/data --nodename db_2


./initgtm -Z gtm -D $PGHOME/../data/gtm/data



./initdb -D $PGHOME/../data/coor_1/data --nodename coor_1
./initdb -D $PGHOME/../data/coor_2/data --nodename coor_2



host    all             all             192.168.150.131/32      trust
host    all             all             0.0.0.0/0               md5




./gtm_ctl -Z gtm -D $PGHOME/../data/gtm/data/ start
./gtm_ctl -Z gtm -D $PGHOME/../data/gtm/data status


./pg_ctl start -D $PGHOME/../data/db_1/data -Z datanode
./pg_ctl start -D $PGHOME/../data/db_2/data -Z datanode
或者
/postgres -X -D $PGHOME/../data/db_1/data
./postgres -X -D $PGHOME/../data/db_2/data


./pg_ctl start -D $PGHOME/../data/coor_1/data -Z coordinator
./pg_ctl start -D $PGHOME/../data/coor_2/data -Z coordinator
或者
./postgres -X -D $PGHOME/../data/coor_1/data
./postgres -X -D $PGHOME/../data/coor_2/data



drop node coor_1;
drop node coor_2;
create node coor_1 with(TYPE=coordinator,HOST='192.168.150.131',PORT=3431);
create node coor_2 with(TYPE=coordinator,HOST='192.168.150.131',PORT=3432);
drop node db_1;
drop node db_2;
create node db_1 with(TYPE=datanode,HOST='192.168.150.131',PORT=4431,primary=false);
create node db_2 with(TYPE=datanode,HOST='192.168.150.131',PORT=4432,primary=false);
alter node coor_1 with(TYPE='coordinator',HOST='192.168.150.131',PORT=3431);
alter node coor_2 with(TYPE='coordinator',HOST='192.168.150.131',PORT=3432);
alter node db_1 with(TYPE=datanode,HOST='192.168.150.131',PORT=4431,primary=true);
alter node db_2 with(TYPE=datanode,HOST='192.168.150.131',PORT=4432,primary=false);
select pgxc_pool_reload();
select * from pgxc_node;



./psql -d postgres -p 3431 -f pgxc_register.sql
./psql -d postgres -p 3432 -f pgxc_register.sql




db_1
listen_addresses = '*'
port = 4431
gtm_host = '192.168.150.131'
gtm_port = 6666

host    all             all             192.168.150.131/32      trust
host    all             all             0.0.0.0/0               md5

db_2
listen_addresses = '*'
port = 4432
gtm_host = '192.168.150.131'
gtm_port = 6666

host    all             all             192.168.150.131/32      trust
host    all             all             0.0.0.0/0               md5



coor_1
listen_addresses = '*'
port = 3431
gtm_host = '192.168.150.131'
gtm_port = 6666
pooler_port = 6661

host    all             all             192.168.150.131/32      trust
host    all             all             0.0.0.0/0               md5

coor_2
listen_addresses = '*'
port = 3432
gtm_host = '192.168.150.131'
gtm_port = 6666 
pooler_port = 6662

host    all             all             192.168.150.131/32      trust
host    all             all             0.0.0.0/0               md5


./gtm_ctl -Z gtm -D $PGHOME/../data/gtm/data/ start
./gtm_ctl -Z gtm -D $PGHOME/../data/gtm/data status


./pg_ctl start -D $PGHOME/../data/db_1/data -Z datanode
./pg_ctl start -D $PGHOME/../data/db_2/data -Z datanode
或者
./postgres -X -D $PGHOME/../data/db_1/data
./postgres -X -D $PGHOME/../data/db_2/data


./pg_ctl start -D $PGHOME/../data/coor_1/data -Z coordinator
./pg_ctl start -D $PGHOME/../data/coor_2/data -Z coordinator
或者
./postgres -X -D $PGHOME/../data/coor_1/data
./postgres -X -D $PGHOME/../data/coor_2/data




./pg_ctl stop -D $PGHOME/../data/coor_2/data -Z coordinator 
./pg_ctl stop -D $PGHOME/../data/coor_1/data -Z coordinator 
./pg_ctl stop -D $PGHOME/../data/db_2/data -Z datanode 
./pg_ctl stop -D $PGHOME/../data/db_1/data -Z datanode 
./gtm_ctl stop -Z gtm -D $PGHOME/../data/gtm/data/



./psql -d postgres -p 3431 -f pgxc_register.sql
./psql -d postgres -p 3432 -f pgxc_register.sql