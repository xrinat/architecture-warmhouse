from flask import Flask, send_from_directory
from flask_swagger_ui import get_swaggerui_blueprint

app = Flask(__name__)

SWAGGER_URL = '/docs'
API_URL = '/docs/openapi.yaml'

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={'app_name': "Тёплый дом - Регистрация устройств"}
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

@app.route("/docs/openapi.yaml")
def send_openapi():
    return send_from_directory("docs", "openapi.yaml")

if __name__ == "__main__":
    app.run(port=8080, debug=True)
