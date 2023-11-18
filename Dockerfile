FROM ros:noetic-ros-base

# Install necessary libraries including libgl1-mesa-glx
RUN apt-get update && apt-get install -y wget libgl1-mesa-glx

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /miniconda && \
    rm /miniconda.sh

ENV PATH /miniconda/bin:${PATH}

# Copy your environment.yml file
COPY environment.yml /environment.yml

# Create the Conda environment
RUN conda env create -f /environment.yml
