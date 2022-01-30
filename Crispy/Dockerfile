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
      silx && \
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
    git \
    libssl1.1 \
    libssl-dev \
    vim \
    libglib2.0-0 && \ 
    apt-get -y upgrade 
    
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install keyboard-configuration       



USER $NB_USER

RUN pip install git+https://github.com/mretegan/crispy 
#ENV PATH=$HOME/.local/bin:$PATH (this line didn't seem necessary in the end)




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
