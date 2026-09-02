from importlib import resources
from pathlib import Path


def get_data_path() -> Path:
    try:
        data_file = resources.files("src.data").joinpath("data.txt")
        if data_file.is_file():
            return Path(str(data_file)).resolve()
    except (ModuleNotFoundError, TypeError):
        pass # Fall through to local relative lookup
    
    #2. Fallback: Try to resolve to the realtive path
    local_path = Path(__file__).resolve().parent / "data" / "data.txt"
    if local_path.is_file():
        return local_path
    
    raise FileNotFoundError("Could not locate 'data.txt' via package resources or local path")

data_file = get_data_path()
print(data_file)