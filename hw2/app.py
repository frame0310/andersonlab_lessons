from flask import Flask, jsonify, request
import emoji

app = Flask(__name__)

@app.route("/", methods=['POST','GET'])
def data():
    if request.method == 'POST':
        r=request.get_json(force=True)
        animal=r['animal']
        sound=r['sound']
        count=r['count']
        output = '{} says {} \n'.format(animal,sound)*count +"Made with love by Sergei Sechkov \n"
        return output
    return "0000000000"
    
if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8080)
