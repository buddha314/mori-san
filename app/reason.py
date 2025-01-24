from flask import Blueprint
# Create basic reason blueprint

reason = Blueprint('reason', __name__)

# Define a route for the blueprint
@reason.route('/reason')
def index():
    return "This is the reason blueprint"

