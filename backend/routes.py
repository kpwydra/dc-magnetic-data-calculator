from flask import jsonify, request

def register_routes(app):
    @app.route("/")
    def home():
        return jsonify({"message": "Flask backend is running!"})

    @app.route("/divideByTwo", methods=["POST"])
    def divideByTwo():
        try:
            number = request.args.get("number")
            if not number:
                return jsonify({"error": "Missing number argument"}), 400
            result = float(number) / 2
            return jsonify({"result": str(result)})
        except Exception as ex:
            return jsonify({"error": str(e)}), 500
