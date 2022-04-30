import os
root = os.getcwd()
PATH_GIT = '/opt/sentiment_analysis'
# PATH_GIT = ''
ROOT = root+PATH_GIT
PATH_CONFIG = ROOT+'/config.json'
PATH_PRE_TRAINED_MODEL= ROOT+"/assets/best_model_state.bin"
PATH_TOKENIZER = ROOT+'/pretrain/tokenizer'
PATH_MODEL_BERT = ROOT+'/pretrain/model'

BERT_MODEL = "bert-base-cased"
CLASS_NAMES = [
    "negative",
    "neutral",
    "positive"
]
MAX_SEQUENCE_LEN =  160