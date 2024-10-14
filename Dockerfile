# 使用基础镜像
FROM centos:centos7

# 设置环境变量
ENV RPATH_FLAGS="-Wl,-rpath,/usr/local/lib:/usr/local/lib/openmpi"
ENV MY_LDFLAGS="-L/usr/local/lib -L/usr/local/lib/openmpi ${RPATH_FLAGS}"
ENV MY_CPPFLAGS="-I/usr/local/include -I/usr/local/include/openmpi"

RUN yum -y install   \
        bison
RUN yum -y install   \
        byacc             \
        cscope            \
        ctags             \
        cvs               \
        diffstat          \
        oxygen            \
        flex              \
        gcc               \
        gcc-c++           \
        gcc-gfortran      \
        gettext           \
        git               \
        indent            \
        intltool          \
        libtool           \
        patch             \
        patchutils        \
        rcs               \
        redhat-rpm-config \
        rpm-build         \
        subversion        \
        systemtap         \
        wget
  RUN   yum -y install    \
        openblas-devel     \
        fftw3-devel        \
        libpng-devel       \
        gsl-devel          \
        gmp-devel          \
        pcre-devel         \
        libtool-ltdl-devel \
        libunistring-devel \
        libffi-devel       \
        gc-devel           \
        zlib-devel         \
        openssl-devel      \
        sqlite-devel       \
        bzip2-devel        \
        ffmpeg
RUN mkdir -p /install

# 下载和安装 SWIG
RUN cd /install && \
    wget https://github.com/swig/swig/archive/rel-3.0.12.tar.gz && \
    tar xvf rel-3.0.12.tar.gz && \
    cd swig-rel-3.0.12 && \
    ./autogen.sh && \
    ./configure && \
    make -j && \
    make -j install

# 下载和安装 Guile
RUN cd /install && \
    wget https://ftp.gnu.org/gnu/guile/guile-2.0.11.tar.gz && \
    tar xvf guile-2.0.11.tar.gz && \
    cd guile-2.0.11 && \
    ./configure && \
    make -j && \
    make -j install

# 下载和安装 Python
RUN cd /install && \
    wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz && \
    tar xvf Python-3.6.5.tgz && \
    cd Python-3.6.5 && \
    ./configure --enable-optimizations && \
    make -j && \
    make -j install

# 下载和安装 OpenMPI
RUN cd /install && \
    wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.1.tar.gz && \
    tar xvf openmpi-2.1.1.tar.gz && \
    cd openmpi-2.1.1/ && \
    ./configure && \
    make -j all && \
    make -j install

# 下载和安装 HDF5
RUN cd /install && \
    git clone https://bitbucket.hdfgroup.org/scm/hdffv/hdf5.git && \
    cd hdf5/ && \
    git checkout tags/hdf5-1_10_2 && \
    ./configure --enable-parallel --enable-shared --prefix=/usr/local CC=/usr/local/bin/mpicc CXX=/usr/local/bin/mpic++ && \
    make -j && \
    make -j install

# 下载和安装 Harminv
RUN cd /install && \
    git clone https://github.com/NanoComp/harminv.git && \
    cd harminv/ && \
    sh autogen.sh --enable-shared && \
    make -j && \
    make -j install

# 下载和安装 Libctl
RUN cd /install && \
    git clone https://github.com/NanoComp/libctl.git && \
    cd libctl/ && \
    sh autogen.sh --enable-shared && \
    make -j && \
    make -j install

# 下载和安装 H5utils
RUN cd /install && \
    git clone https://github.com/NanoComp/h5utils.git && \
    cd h5utils/ && \
    sh autogen.sh CC=/usr/local/bin/mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" && \
    make -j && \
    make -j install

# 下载和安装 MPB
RUN cd /install && \
    git clone https://github.com/NanoComp/mpb.git && \
    cd mpb/ && \
    sh autogen.sh --enable-shared CC=/usr/local/bin/mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --with-hermitian-eps && \
    make -j && \
    make -j install

# 下载和安装 libGDSII
RUN cd /install && \
    git clone https://github.com/HomerReid/libGDSII.git && \
    cd libGDSII/ && \
    sh autogen.sh && \
    make -j install

# 下载和安装 mpi4py
RUN cd /install && \
    wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.0.tar.gz && \
    tar xvf mpi4py-3.0.0.tar.gz && \
    cd mpi4py-3.0.0/ && \
    python3 setup.py build && \
    /usr/local/bin/python3 setup.py install

# 下载和安装 h5py
RUN cd /install && \
    wget https://github.com/h5py/h5py/archive/2.8.0.tar.gz && \
    tar xvf 2.8.0.tar.gz && \
    cd h5py-2.8.0/ && \
    python3 setup.py configure --mpi && \
    python3 setup.py build && \
    /usr/local/bin/python3 setup.py install

