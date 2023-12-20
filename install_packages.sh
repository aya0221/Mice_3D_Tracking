# Use the official ROS Noetic base image
FROM ros:noetic-robot

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-rosbag \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Set up the Conda environment (assuming 'myp' is your environment name)
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Activate the conda environment and install the Python packages
RUN /bin/bash -c "source activate myp && \
    conda install imgaug numba h5py && \
    pip install tqdm colour tensorboard cmocean && \
    pip install filterpy pyquaternion pywaffle && \
    pip install palettable && \
    pip install future && \
    pip install pyfirmata && \
    pip install shapely && \
    pip install git+https://github.com/daavoo/pyntcloud && \
    conda install pytorch torchvision cudatoolkit=<your_cuda_version> -c pytorch && \
    pip install pyro-ppl && \
    pip install gnupg && \
    pip install pyrosbag"

# Continue with the rest of your setup...
