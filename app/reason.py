from flask import Blueprint, request

# Create basic reason blueprint

reason = Blueprint("reason", __name__)


# Define a route for the blueprint
# add POST to the route to accept data
@reason.route("/reason", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        # pull the alarm_whiteboard from the request json
        alarm_whiteboard = request.get_json()
        return alarm_whiteboard
    return "This is the reason blueprint"
