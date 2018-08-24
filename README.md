# fftw2-deploy

[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=fftw2-deploy)](https://ci.sagrid.ac.za/job/fftw2-deploy)

Build, test and deploy scripts necessary to deploy [FFTW2](http://www.fftw.org) for CODE-RADE

## Versions

  * 2.1.5

## Dependencies

This project depends on

  * OpenMPI

## Configuration

The following configuration is used to build the project :

```
CFLAGS='-fPIC' ./configure \
--prefix=$SOFT_DIR-gcc-${GCC_VERSION}-mpi-${OPENMPI_VERSION} \
--enable-mpi \
--enable-shared \
--enable-threads \
--enable-openmp \
--with-pic

```

# Citing
