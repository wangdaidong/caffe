#FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04
FROM ubuntu:22.04
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone



#RUN sed -i "s@http://.*archive.ubuntu.com@https://mirrors.zju.edu.cn@g" /etc/apt/sources.list
#RUN sed -i "s@http://.*security.ubuntu.com@https://mirrors.aliyun.com@g" /etc/apt/sources.list

#COPY sources.list /etc/apt/
RUN apt-get update
RUN apt-get upgrade -y 

RUN apt-get install --reinstall ca-certificates -y

COPY sources.list /etc/apt/
RUN apt-get update
RUN apt-get upgrade -y 

RUN apt-get install -y build-essential cmake cmake-curses-gui git unzip pkg-config \
    libjpeg-dev libpng-dev libtiff-dev openssh-server \
    libavcodec-dev libavformat-dev libswscale-dev libswresample-dev \
    libgtk2.0-dev libcanberra-gtk* \
    python3-dev python3-pip \
    libxvidcore-dev libx264-dev libgtk-3-dev \
    libtbb2 libtbb-dev libdc1394-dev \
    libv4l-dev v4l-utils cmake-curses-gui \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libvorbis-dev libxine2-dev \
    libfaac-dev libmp3lame-dev libtheora-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    libopenblas-dev libatlas-base-dev libblas-dev \
    liblapack-dev libeigen3-dev gfortran \
    libhdf5-dev protobuf-compiler \
    libprotobuf-dev libgoogle-glog-dev libgflags-dev \
    libprotobuf-dev libleveldb-dev liblmdb-dev \
    libsnappy-dev libhdf5-serial-dev protobuf-compiler \
    libatlas-base-dev libopenblas-dev   the  graphviz \
    libopencv-apps-dev    libopencv-calib3d-dev \
    libopencv-contrib-dev    libopencv-core-dev\
    libopencv-dev    libopencv-dnn-dev \
    libopencv-features2d-dev    libopencv-flann-dev \
    libopencv-highgui-dev    libopencv-imgcodecs-dev \
    libopencv-imgproc-dev    libopencv-ml-dev \
    libopencv-objdetect-dev    libopencv-photo-dev \
    libopencv-shape-dev    libopencv-stitching-dev\
    libopencv-superres-dev    libopencv-video-dev\
    libopencv-videoio-dev    libopencv-videostab-dev    libopencv-viz-dev \
    --no-install-recommends libboost-all-dev \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s -f /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h

RUN mkdir /root/.pip
#COPY pip.conf /root/.pip/
#RUN  ls   /usr/lib/x86_64-linux-gnu/|grep libopencv
COPY ./ /opt/caffe
WORKDIR /opt/caffe
RUN cp pip.conf /root/.pip/ && pip install -r requirements.txt  


#WORKDIR /opt/

RUN make -j 128 && make test -j 128 \ 
  && make pycaffe -j 128 

RUN service ssh start 
ENV PYTHONPATH=$PYTHONPATH:/opt/caffe/python
ENV PATH=$PATH:/opt/caffe/build/tools


# RUN git clone https://github.com/BVLC/caffe.git
#RUN git clone https://github.com/Qengineering/caffe.git
#COPY caffe /opt/caffe

# 添加 upsample 算子
#RUN git clone https://github.com/SeanQ88/caffe_upsample.git
#RUN cp caffe_upsample/upsample_layer.hpp caffe_upsample/upsample_layer.cpp caffe_upsample/upsample_layer.cu /opt/caffe/src/caffe/layers/

#RUN sed -n '545p' caffe_upsample/caffe.proto | sed -i '544 r /dev/stdin' /opt/caffe/src/caffe/proto/caffe.proto
#RUN sed -n '1924,1927p' caffe_upsample/caffe.proto >> /opt/caffe/src/caffe/proto/caffe.proto



#RUN cd /opt/caffe/ \
#    && make -j 128 && make test -j 128 \ 
#    && make pycaffe -j 128 

WORKDIR /root/

#https://zhuanlan.zhihu.com/p/602843230
