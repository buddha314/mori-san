from flask import Flask
from flask import Blueprint, render_template, abort
from reason import reason  # Import the reason blueprint
from asgiref.wsgi import WsgiToAsgi


# generate a basic Flask app
app = Flask(__name__)

# Register the reason blueprint
app.register_blueprint(reason)

asgi_app = WsgiToAsgi(app)
if __name__ == '__main__':
    import uvicorn
    uvicorn.run(asgi_app, host="127.0.0.1", port=8000)
