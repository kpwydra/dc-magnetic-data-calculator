# dc-magnetic-data-calculator

# Create Python Virtual Environment (only once at project start)
> [!IMPORTANT]
> Must know, allows to isolate projects' dependencies
```
python3 -m venv .venv
```

## Install requirements
> [!IMPORTANT]
> Make sure that `which python` command returns the venv path, restart the terminal to load venv
```
pip3 install -r requirements.txt
pip3 install -r requirements-dev.txt
```

## Running backend
> Run the following command to setup the backend server locally.
```
python -m backend.app
```

## Configure Environment
> Create `.env` file with content below. On Windows, use `;` separator, on Linux use `:`
```
PYTHONPATH=./;./src;./tests
```