FROM ubuntu:18.04
MAINTAINER <abc@gmail.com>
FROM python:3.7

ENV DISPLAY :1
#ENV NVIDIA_VISIBLE_DEVICES all
#ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
RUN apt install apt-transport-https curl gnupg && curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
RUN mv bazel.gpg /etc/apt/trusted.gpg.d/ && echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && apt update && apt install -y bazel openjdk-11-jdk
COPY . .
RUN apt update && apt install -y g++ unzip zip libpython3.7-dev python-numpy gettext libsdl2-dev mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev libosmesa6-dev libgl1-mesa-glx mesa-utils \
libxext6 libx11-6 freeglut3-dev
#WORKDIR /usr/include/numpy/
RUN sed -i 's/Python.h/python3.7\/Python.h/g' /usr/include/numpy/ndarrayobject.h && sed -i 's/Python.h/python3.7\/Python.h/g' /usr/include/numpy/npy_common.h
RUN cd lab && bazel build -c opt --python_version=PY3 //python/pip_package:build_pip_package && ./bazel-bin/python/pip_package/build_pip_package /tmp/dmlab_pkg && pip install /tmp/dmlab_pkg/deepmind_lab-1.0-py3-none-any.whl --force-reinstall
#COPY requirements.txt /tmp
#WORKDIR /tmp
RUN pip install --upgrade pip && \
    pip install -r requirements.txt &&\
    mkdir /root/.mujoco
RUN version="3.1" && \
wget "https://github.com/glfw/glfw/releases/download/${version}/glfw-${version}.zip" && \
unzip glfw-${version}.zip && \
cd glfw-${version} && \
apt-get install -y cmake xorg-dev libglu1-mesa-dev && \
cmake -G "Unix Makefiles" && \
make && \
make install
#WORKDIR /
COPY mujoco /root/.mujoco
#RUN apt-get install -y libglew-dev libglfw3-dev && LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so:/usr/lib/nvidia-384/libGL.so python
#RUN export DISPLAY=:0 && glxinfo | grep OpenGL
CMD bash start.sh
