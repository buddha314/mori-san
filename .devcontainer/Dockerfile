FROM continuumio/miniconda3:24.11.1-0
USER root

ENV PATH="/root/.cargo/bin:${PATH}"

# Inspired by https://github.com/scallop-lang/scallop-docker/blob/main/Dockerfile
# Install system dependencies
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install wget gcc \
    libsm6 libxext6 git curl make build-essential

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
RUN rustup toolchain install nightly --allow-downgrade --profile minimal --component miri
RUN rustup default nightly

# Install Python 3.10
RUN conda update -y conda && \
    conda create --name myenv python=3.10 -y && \
    conda clean -afy

# Install Poetry and cargo
WORKDIR /workspaces/mori-san
RUN pip install poetry
# Configure Poetry to avoid virtualenv creation
RUN poetry config virtualenvs.create false
COPY poetry.lock .
COPY pyproject.toml . 
RUN poetry install --no-interaction --no-ansi --no-root
#RUN poetry install

WORKDIR /root/project

# Clone scallop
RUN git clone https://github.com/scallop-lang/scallop


# Install scallop from source
WORKDIR /root/project/scallop
COPY scallop .
# Build scallop
RUN make install-scli
RUN make install-sclc
RUN make install-sclrepl
RUN make install-scallopy

WORKDIR /workspaces/mori-san
