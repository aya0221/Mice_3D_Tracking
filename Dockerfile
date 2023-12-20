# Use ROS base image
FROM ros:noetic-robot

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget git software-properties-common python3-empy libgl1-mesa-glx \
    python3-rosdep python3-rosinstall python3-rosinstall-generator \
    python3-wstool build-essential && rm -rf /var/lib/apt/lists/*

# OpenCV repository
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" 

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
RUN bash /tmp/miniconda.sh -b -p /miniconda
ENV PATH="/miniconda/bin:$PATH"

# Create Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# rosdep update
RUN rosdep update

# Create workspace
RUN mkdir -p ~/catkin_ws/src

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]