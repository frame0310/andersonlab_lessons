from types import MethodDescriptorType
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/", methods=['POST'])
def hello():
    return jsonify(data)
    
##@app.route("/health")
##def health():
##    return jsonify({'status': 'ok'})

if __name__ == "__main__":
    app.run(host='127.0.0.1')