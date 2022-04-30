FROM python:3.8
MAINTAINER Tan Nguyen <ndtan.hcm@gmail.com.vn>


# Install build utilities
RUN apt-get update && \
    apt-get install -y protobuf-compiler python3-pil python3-lxml python3-pip python3-dev git && \
    apt-get -y upgrade

RUN cd $HOME && \
    git clone https://github.com/ndtands/sentiment_analysis.git && \
    cp -a sentiment_analysis /opt/ && \
    chmod u+x /opt/sentiment_analysis/app.py
RUN pip install gdown
RUN pip install -r /opt/sentiment_analysis/requirements.txt
RUN gdown https://drive.google.com/uc?id=1V8itWtowCYnb2Bc9KlK9SxGff9WwmogA
RUN mkdir /opt/sentiment_analysis/assets && \
    mkdir /opt/sentiment_analysis/pretrain && \
    mkdir /opt/sentiment_analysis/pretrain && \
    mkdir /opt/sentiment_analysis/pretrain/model

RUN python3 /opt/sentiment_analysis/set_up.py

RUN mv best_model_state.bin /opt/sentiment_analysis/assets

# expose ports
EXPOSE 5002

#Command
CMD ["python3", "/opt/sentiment_analysis/app.py"]