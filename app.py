from flask import Flask, abort, render_template, jsonify, send_from_directory
import os
import json  # <-- Add this import

app = Flask(__name__, template_folder="templates")

# Load JSON data
def load_data():
    with open("data.json", "r") as file:
        return json.load(file)

# Route to serve the map
@app.route("/map")
def home():
    data = load_data()
    return render_template("map.html", leaders=data["leaders"])

@app.route("/")
def serve_index():
    return render_template("index.html")

@app.route('/<path:page>')
def serve_page(page):
    # Default to 'index.html' if no page is specified or root is accessed
    if page == '':
        page = 'index.html'
    elif not page.endswith('.html'):
        page += '.html'

    # Check if the file exists in the templates folder
    try:
        return render_template(page)
    except:
        # Return 404 if the file doesn’t exist
        abort(404)

@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

# Route to provide JSON API
@app.route("/api")
def api():
    return jsonify(load_data())

# Route to serve leader images
@app.route('/images/<filename>')
def get_image(filename):
    return send_from_directory(os.path.join(app.root_path, 'images'), filename)

# Run Flask app
if __name__ == "__main__":
    app.run(debug=True)
