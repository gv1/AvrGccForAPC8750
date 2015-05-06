# Cross compile GCC for APC 8750 ( arm-none-linux-gnueabi ) with target avr.
set -x
set -e
test -d gmp-6.0.0 && rm -rf gmp-6.0.0
time tar xf $SRC/gmp-6.0.0a.tar.xz 
test -d mpfr-3.1.2 && rm -rf mpfr-3.1.2
time tar xf $SRC/mpfr-3.1.2.tar.xz 
test -d binutils-2.25 && rm -rf binutils-2.25
time tar xf $SRC/binutils-2.25.tar.bz2 
test -d gcc-4.9.2 && rm -rf gcc-4.9.2
time tar xf $SRC/gcc-4.9.2.tar.bz2 
test -d avr-libc-1.8.0 && rm -rf avr-libc-1.8.0
time tar xf $SRC/avr-libc-1.8.0.tar.bz2
test -d mpc-1.0.1 && rm -rf mpc-1.0.1
time tar xf $SRC/mpc-1.0.1.tar.gz

export PREFIX=/opt/local/apc
export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
HOST=arm-none-linux-gnueabi
CC=$HOST-gcc
AS=$HOST-as

cd gmp-6.0.0
test -f Makefile && make distclean
time ./configure --host=$HOST CC=$CC AS=$AS --prefix=$PREFIX --enable-shared
time make -j 4
make install
cd ..

cd mpfr-3.1.2
test -f Makefile && make distclean
time ./configure --with-gmp=$PREFIX  --prefix=$PREFIX --host=$HOST CC=$CC AS=$AS --with-gmp=$PREFIX
time make -j 4
make install
cd ..

cd binutils-2.25
test -d obj && rm -rf obj
test -d obj || mkdir obj
cd obj
test -f Makefile && make distclean

time ../configure --with-gmp=$PREFIX --with-mpfr=$PREFIX --prefix=$PREFIX --host=$HOST --target=avr --disable-nls \
	CC=$CC AS=$AS
time make -j 4
make install
time make -j 4 html
make install-html
cd ../..

cd mpc-1.0.1
test -f Makefile && make distclean
time ./configure --with-gmp=$PREFIX --with-mpfr=$PREFIX --prefix=$PREFIX --host=$HOST
time make -j 4
make install
cd ..

cd gcc-4.9.2
test -d obj && rmdir obj
test -d obj || mkdir obj
cd obj
test -f Makefile && make distclean
time ../configure --prefix=$PREFIX --host=$HOST --target=avr --enable-languages=c,c++     --disable-nls --disable-libssp --with-dwarf2 --with-mpfr=$PREFIX --with-gmp=$PREFIX --with-mpc=$PREFIX --disable-bootstrap --disable-stage1-checking CC=$CC AS=$AS
time make -j 4
make install
cd ../..

# do this on apc8750, requires the new compiler
# cd avr-libc-1.8.0
# time ./configure --prefix=/opt/local/apc/ --build=i686-pc-linux-gnu --host=avr
# time make -j 4
# make install
# cd ..


