from transformers import BertTokenizer, BertModel
from path import *
import logging
import time
import sys
import os
# LOGGING SETUP
logger = logging.getLogger('Save Pretrain')
logger.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s %(filename)s: %(levelname)s: %(message)s","%Y-%m-%d %H:%M:%S")
logging.Formatter.converter = time.gmtime
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)

tokenizer = BertTokenizer.from_pretrained(BERT_MODEL)
model = BertModel.from_pretrained(BERT_MODEL)
tokenizer.save_pretrained(PATH_TOKENIZER)
model.save_pretrained(PATH_MODEL_BERT)
logger.info('save pretrain done!!!')