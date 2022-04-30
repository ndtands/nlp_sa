#STEP1: PULL image python
FROM python:3.8

#STEP2
MAINTAINER Tan Nguyen <ndtan.hcm@gmail.com.vn>


#STEP3: Install build utilities
RUN apt-get update && \
    apt-get install -y protobuf-compiler python3-pil python3-lxml python3-pip python3-dev git && \
    apt-get -y upgrade

#STEP4: Clone git and setting workplace
RUN cd $HOME && \
    git clone https://github.com/ndtands/nlp_sa.git && \
    cp -a nlp_sa /opt/ && \
    chmod u+x /opt/nlp_sa/app.py

#STEP5: Install gdown and install requirements
RUN pip install gdown && \
    pip install -r /opt/nlp_sa/requirements.txt

#STEP6: Download weight 
RUN gdown https://drive.google.com/uc?id=1V8itWtowCYnb2Bc9KlK9SxGff9WwmogA

#STEP7: Create some folder
RUN mkdir /opt/nlp_sa/assets && \
    mkdir /opt/nlp_sa/pretrain && \
    mkdir /opt/nlp_sa/pretrain/tokenizer && \
    mkdir /opt/nlp_sa/pretrain/model

#STEP8: Run setp for dowload pretrain of BERT
RUN python3 /opt/nlp_sa/set_up.py

#STEP9: Move weight file to Folder in Docker
RUN mv best_model_state.bin /opt/nlp_sa/assets

#STEP10: Expose ports
EXPOSE 5002

#STEP11: Run App
CMD ["python3", "/opt/nlp_sa/app.py"]