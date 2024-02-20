from flask import Flask, request, render_template
import geocoder

app = Flask(__name__, static_url_path='')

@app.route("/", methods=['GET'])
def home():
    return render_template('home.html')

@app.route('/echo/<string:user_string>', methods=['GET'])
def echo(user_string):
    return render_template('show_text.html', user_string=user_string)

@app.route('/ip', methods=['GET'])
def ip():
    ip_addr = request.remote_addr
    # Fallback to a default IP for testing purposes
    if ip_addr == "127.0.0.1" or not ip_addr:
        ip_addr = "8.8.8.8"
    g = geocoder.ip(ip_addr)

    return render_template('location.html', ip_address=ip_addr, country=g.country, city=g.city, coordinates=g.latlng)

@app.route('/index.html', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/status', methods=['GET'])
def status():
    return 'OK'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
