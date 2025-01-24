FROM --platform=linux/amd64 ubuntu:24.04
USER root

ENV PATH="/root/.cargo/bin:/root/miniconda3/bin:${PATH}"

# Inspired by https://github.com/scallop-lang/scallop-docker/blob/main/Dockerfile
# Install system dependencies
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install wget gcc \
    libsm6 libxext6 git curl make build-essential

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
RUN rustup toolchain install nightly --allow-downgrade --profile minimal --component miri
RUN rustup default nightly

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b && \
    rm ./Miniconda3-latest-Linux-x86_64.sh

# Install Python 3.10
RUN conda update -y conda && \
    conda create --name myenv python=3.10 -y && \
    conda clean -afy

# Install Poetry and cargo
RUN pip install poetry cargo maturin

# Configure Poetry to avoid virtualenv creation
RUN poetry config virtualenvs.create false

# Install scallop from source
WORKDIR /root
RUN git clone https://github.com/scallop-lang/scallop.git
WORKDIR /root/scallop

WORKDIR /root/scallop
COPY scallop .

# Build scallop
RUN pip install maturin
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-scli"
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-sclc"
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-sclrepl"
RUN /bin/bash -c "source '$HOME/.cargo/env' ; make install-scallopy"

# Add application and scallop files

WORKDIR /workspaces/mori-san
#RUN poetry install