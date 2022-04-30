# nlp_sa
- BERT + Sentiment analysis
- Bert model save in gg drive: https://drive.google.com/uc?id=1V8itWtowCYnb2Bc9KlK9SxGff9WwmogA
- Api with flaskAPI

#Setup in gcp
- Create VM:
  + E2-standard4
  + ubuntu20.4 20GB
- Create VPC Network
  + Port range: 5000 - 8000
- Open SSH of VM and setup:
```
sudo apt-get update
sudo apt-get install docker.io
gcloud auth configure-docker
sudo -s
apt-get update
apt-get install -y protobuf-compiler python3-pil python3-lxml python3-pip python3-dev git
pip3 install -U pip
```
- Build docker and run container
```
sudo docker build -t nlp-sa:latest .
sudo docker run --rm -p 5002:5002 nlp-sa:latest
```
- Run app with url: http://[EXTERNAL_IP]:8000
