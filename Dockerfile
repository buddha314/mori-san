FROM --platform=linux/amd64 ubuntu:24.04
USER root

# Inspired by https://github.com/scallop-lang/scallop-docker/blob/main/Dockerfile 

# Install system dependencies
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install wget gcc \
    libsm6 libxext6 git curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN /bin/bash -c "source '$HOME/.cargo/env' ; rustup default nightly"

RUN apt install -y make

RUN apt update && apt upgrade -y
RUN apt install -y build-essential

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b && \
    rm ./Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/root/miniconda3/bin:${PATH}"

# Install Python 3.10
RUN conda update -y conda && \
    conda create --name myenv python=3.10 -y && \
    conda clean -afy

# Activate Conda environment
ENV PATH="/root/miniconda3/envs/myenv/bin:${PATH}"

# Verify Python installation
RUN python --version && pip --version

# Install Poetry and cargo
RUN pip install poetry cargo

# Configure Poetry to avoid virtualenv creation
RUN poetry config virtualenvs.create false

# Install scallop from source
WORKDIR /root/src
RUN git clone https://github.com/scallop-lang/scallop.git
WORKDIR /root/src/scallop

# Build scallop
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-scli"
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-sclc"
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-sclrepl"

# Add application and scallop files
WORKDIR /root/project
#COPY ./bins/scli /root/packages/scallop/bin/scli
#COPY ./bins/sclrepl /root/packages/scallop/bin/sclrepl
COPY . .


WORKDIR /root/src/scallop
RUN pip install maturin
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-scallopy"