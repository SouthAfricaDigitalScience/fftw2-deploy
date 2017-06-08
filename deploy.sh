#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
module add mpc
module add mpfr
module add gmp
module add gcc/${GCC_VERSION}
module add openmpi/${OPENMPI_VERSION}-gcc-${GCC_VERSION}
# we need sse and single precision for gromacs
echo ${SOFT_DIR}-gcc-${GCC_VERSION}-mpi-${OPENMPI_VERSION}
cd ${WORKSPACE}/${NAME}-${VERSION}/
make distclean
echo "All tests have passed, will now build into ${SOFT_DIR}-gcc-${GCC_VERSION}"
echo "Configuring the deploy"
CFLAGS='-fPIC' ./configure  \
--prefix=$SOFT_DIR-gcc-${GCC_VERSION}-mpi-${OPENMPI_VERSION} \
--enable-mpi \
--enable-shared \
--enable-threads \
--enable-openmp \
--with-pic
make install
echo "Creating the modules file directory ${LIBRARIES}"
mkdir -p ${LIBRARIES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module add gmp
module add mpfr
module add mpc
module add ncurses
module add gcc/${GCC_VERSION}
module add openmpi/${OPENMPI_VERSION}-gcc-${GCC_VERSION}

module-whatis   "$NAME $VERSION. compiled for OpenMPI ${OPENMPI_VERSION} and GCC version ${GCC_VERSION}"
setenv       FFTW_VERSION               $VERSION
setenv       FFTW_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}-mpi-${OPENMPI_VERSION}

prepend-path 	  PATH                         $::env(FFTW_DIR)/bin
prepend-path    PATH                         $::env(FFTW_DIR)/include
prepend-path    PATH                         $::env(FFTW_DIR)/bin
prepend-path    MANPATH                $::env(FFTW_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(FFTW_DIR)/lib
MODULE_FILE
) > ${LIBRARIES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}-mpi-${OPENMPI_VERSION}


# Testing module
module avail
module list
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}-mpi-${OPENMPI_VERSION}
echo "PATH is : $PATH"
echo "LD_LIBRARY_PATH is $LD_LIBRARY_PATH"
# confirm openmpi
