from flask import Flask, request, render_template
from typing import Dict
from pydantic import BaseModel

from model import Model, get_model

app = Flask(__name__)
model  = get_model()
@app.route('/')
def my_form():
    return render_template('form.html')

@app.route('/', methods=['POST'])
def my_form_post():
    
    #convert to lowercase
    text1 = request.form['text1']
    sentiment, confidence, probabilities = model.predict(text1)
    neg = f"{probabilities['negative']*100: .2f} %"
    neu = f"{probabilities['neutral']*100: .2f} %"
    pos = f"{probabilities['positive']*100: .2f} %"
    return render_template(
        'form.html',
        text1=text1,
        final=round(confidence.cpu().detach().numpy()[0]*100,2),
        text2 = pos ,
        text3 = neu,
        text5 = neg,
        status = sentiment
        )

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=5002, threaded=True)


#transformer==2.8