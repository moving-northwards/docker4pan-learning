FROM jupyter/base-notebook

USER $NB_USER

RUN conda install --yes \
      -c conda-forge \
      h5py \
      ipympl \
      ipython \
      ipywidgets \
      jupyterlab \
      jupyterlab_widgets \
      jupyter_nbextensions_configurator \
      matplotlib-base \
      nodejs \
      python-confluent-kafka \
      pythreejs \
      voila \
      bqplot \
      ipyvolume \
      ipympl \
      #  The next are all specifically needed for SimEx
      markdown \
      py3nvml \
      biopython \
      cython \
      dill \
      mpi4py \
      openpmd-api \
      periodictable \
      pint \
      pyFAI \
      numba \
      xraydb && \
    conda install -c intel mkl && \
    conda clean -afy

RUN conda update -n base conda --yes

RUN jupyter serverextension enable voila --sys-prefix





USER root

SHELL [ "/bin/bash", "--login", "-c" ]

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    apt-utils  \
    build-essential \
    gfortran \
    libgsl0-dev \
    libbz2-dev \
    hdf5-tools \
    libfftw3-dev \
    git \
    libssl1.1 \
    libssl-dev \
    vim \
    wget \
    libgsl-dev \
    cmake && \
    apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install keyboard-configuration



##### Installing SimEx #####

# first add ocelot
RUN git clone https://github.com/ocelot-collab/ocelot.git -b dev_gen --depth 1
RUN cd ocelot && \
    pip install .


RUN git clone https://github.com/PaNOSC-ViNYL/SimEx -b master --depth 1
RUN cd SimEx && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/conda \
          -DUSE_wpg=ON \
          -DUSE_SingFELPhotonDiffractor=ON \
          -DUSE_XMDYNPhotonMatterInteractor=ON \
          -DUSE_S2EReconstruction_DM=ON \
          -DUSE_S2EReconstruction_EMC=ON \
          .. && \
    make -j8 && \
    make install && \
    cd ../Sources/python && \
    pip install .


############################

# Jupyter NB extentions -copied from trnielsen
USER root

RUN pip install jupyter_contrib_nbextensions
RUN pip install nbgitpuller
RUN jupyter contrib nbextension install 

# enable the Nbextensions
RUN jupyter serverextension enable --py nbgitpuller 
RUN jupyter nbextension enable contrib_nbextensions_help_item/main
RUN jupyter nbextension enable autosavetime/main
RUN jupyter nbextension enable execute_time/ExecuteTime 
RUN jupyter nbextension enable spellchecker/main
RUN jupyter nbextension enable toc2/main

# Install necessary jupyter packages for writing here. e.g.
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension



USER $NB_USER
# Clean up - Remove .cache  directory
RUN rm -r "/home/$NB_USER/.cache"

USER $NB_UID

WORKDIR $HOME
