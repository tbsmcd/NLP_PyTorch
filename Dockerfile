FROM ubuntu:20.04

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ENV PYTHONIOENCODING "utf-8"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN apt-get install -y libffi-dev
RUN apt-get install -y gcc
RUN apt-get install -y unzip
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y file
RUN apt-get install -y libbz2-dev
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y language-pack-ja

# use to work...
RUN apt-get install -y vim
RUN apt-get install -y cron
RUN apt-get install -y tree

# MeCab
WORKDIR /opt
RUN git clone https://github.com/taku910/mecab.git
WORKDIR /opt/mecab/mecab
RUN ./configure  --enable-utf8-only \
  && make && make check && make install && ldconfig
WORKDIR /opt/mecab/mecab-ipadic
RUN ./configure --with-charset=utf8 && make && make install

# neolog-ipadic
# Changing the MeCab dictionary
WORKDIR /opt
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
WORKDIR /opt/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y

# Japanese font
WORKDIR /opt
RUN wget http://moji.or.jp/wp-content/ipafont/IPAfont/ipag00303.zip
RUN unzip ipag00303.zip
RUN mkdir -p /usr/share/fonts/
RUN cp ipag00303/ipag.ttf /usr/share/fonts/ipa

# BERT pretrained Japanese model
WORKDIR /opt
RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/JapaneseBertPretrainedModel/Japanese_L-12_H-768_A-12_E-30_BPE_WWM_transformers.zip
# /opt/bert_model_ja
RUN unzip Japanese_L-12_H-768_A-12_E-30_BPE_WWM_transformers.zip -d bert_model_ja

# pip
WORKDIR /opt
RUN pip3 install mecab-python3
RUN pip3 install numpy
RUN pip3 install pandas
RUN pip3 install matplotlib
RUN pip3 install mojimoji
# PyTorch は CPU 版
RUN pip3 install torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
# BERT
RUN pip3 install transformers

# run
WORKDIR /