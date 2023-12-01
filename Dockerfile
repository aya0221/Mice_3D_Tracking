# Use the official ROS Noetic base image
FROM ros:noetic-robot

# Install system dependencies necessary for installing Miniconda and Git
RUN apt-get update && apt-get install -y \
    wget \
    git \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add the repository for OpenCV
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" 

# Install Miniconda to manage Python environments
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
RUN bash /tmp/miniconda.sh -b -p /miniconda
ENV PATH="/miniconda/bin:$PATH"

# Set up the Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Update rosdep
RUN rosdep update

# Create a catkin workspace
RUN mkdir -p ~/catkin_ws/src
WORKDIR /root/catkin_ws

# Clone the vision_opencv repo (contains cv_bridge)
RUN git clone -b noetic https://github.com/ros-perception/vision_opencv.git src/vision_opencv

# Install cv_bridge dependencies
RUN apt-get update && rosdep install --from-paths src --ignore-src -r -y

# Build the catkin workspace
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make'

# Source the workspace
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
