
VERSION=1.8.0
CC=cc

# optional features
M_STATIC=0
M_FILL=0
DSL_PY=0
DXL_EXC=0

EXPAT_H="<expat.h>"
UNISTD_H="<unistd.h>"
PY_H="<scm/scm.h>"

INC=-I/usr/local/include ${CPPFLAGS}
LBL=-L/usr/local/lib ${LDFLAGS}

DEF=\
-DM_STATIC=${M_STATIC} \
-DM_FILL=${M_FILL} \
-DEXPAT_H=${EXPAT_H} \
-DUNISTD_H=${UNISTD_H} \
-DRNV_VERSION="\"${VERSION}\"" \
-DARX_VERSION="\"${VERSION}\"" \
-DRVP_VERSION="\"${VERSION}\""
WARN=-Wall -Wstrict-prototypes  -Wmissing-prototypes -Wcast-align
OPT=-O -g

CFLAGS=${INC} ${DEF} ${WARN} ${OPT}
LFLAGS=${OPT} ${LBL}

LIBEXPAT=-lexpat
LIB_PY=-lscm -lm \
`sh -c '[ -f /usr/lib/libdl.a ] && echo -ldl \
      ; [ -f /usr/lib/libsocket.a ] && echo -lsocket \
'` 

LIB=${LIBEXPAT}

ifeq (${DSL_PY},1)
DEF+=-DDSL_PY=${DSL_PY} -DPY_H=${PY_H}
LIB+=${LIB_PY}
endif

ifeq (${DXL_EXC},1)
DEF+=-DDXL_EXC=${DXL_EXC}
endif

LIBRNVA=librnv.a
LIBRNVSO=librnv.so
LIBRNV=${LIBRNVA}

SRC=\
ll.h \
erbit.h \
xcl.c \
arx.c \
rvp.c \
xsdck.c \
test.c \
ary.c ary.h \
rn.c rn.h \
rnc.c rnc.h \
rnd.c rnd.h \
rnl.c rnl.h \
rnv.c rnv.h \
rnx.c rnx.h \
drv.c drv.h \
xsd.c xsd.h \
xsd_tm.c xsd_tm.h \
dxl.c dxl.h \
dsl.c dsl.h \
sc.c sc.h \
ht.c ht.h \
er.c er.h \
u.c u.h \
xmlc.c xmlc.h \
s.c s.h \
m.c m.h \
rx.c rx.h \
rx_cls_u.c \
rx_cls_ranges.c

OBJ=\
rn.o \
rnc.o \
rnd.o \
rnl.o \
rnv.o \
rnx.o \
drv.o \
ary.o \
xsd.o \
xsd_tm.o \
dxl.o \
dsl.o \
sc.o \
u.o \
ht.o \
er.o \
xmlc.o \
s.o \
m.o \
rx.o

.SUFFIXES: .c .o

.c.o:
	${CC} ${CFLAGS} -c -o $@ $<

all: rnv arx rvp xsdck test

rnv: xcl.o ${LIBRNV}
	${CC} ${LFLAGS} -o rnv xcl.o ${LIBRNV} ${LIB}

arx: arx.o ${LIBRNV}
	${CC} ${LFLAGS} -o arx arx.o ${LIBRNV} ${LIB}

rvp: rvp.o ${LIBRNV}
	${CC} ${LFLAGS} -o rvp rvp.o ${LIBRNV} ${LIB}

xsdck: xsdck.o ${LIBRNV}
	${CC} ${LFLAGS} -o xsdck xsdck.o ${LIBRNV} ${LIB}

test: test.o ${LIBRNV}
	${CC} ${LFLAGS} -o test test.o ${LIBRNV} ${LIB}

${LIBRNVA}: ${OBJ}
	ar rc $@ ${OBJ}
	ranlib ${LIBRNVA}

${LIBRNVSO}: ${OBJ}
	gcc -shared -o $@ ${OBJ}

depend: ${SRC}
	makedepend -Y ${DEF} ${SRC}

clean:
	-rm -f *.o tst/c/*.o  *.a *.so rnv arx rnd_test *_test *.core *.gmon *.gprof rnv*.zip rnv.txt rnv.pdf rnv.html rnv.xml

rnd_test: ${LIBRNV} tst/c/rnd_test.c
	${CC} ${LFLAGS} -I. -o rnd_test tst/c/rnd_test.c ${LIBRNV} ${LIB}

