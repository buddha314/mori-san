import pytest
import sys, os, json
# Add the app directory to the sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../app')))

from main import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_reason_endpoint(client):
    response = client.get("/reason")
    assert response.status_code == 200
    assert response.data.decode('utf-8') == "This is the reason blueprint"

def test_alarm_whiteboard(client):
    with open("tests/data/alarm_test.json") as f:
        # read f as json
        alarm_whiteboard = json.load(f)
        response = client.post("/reason", json={"alarm_whiteboard": alarm_whiteboard})
        assert response.status_code == 200
        j = response.get_json()
        print(json.dumps(j, indent=2))
        open("tests/data/alarm_test_output.json", "w").write(json.dumps(j, indent=2))
        assert len(j) == 3