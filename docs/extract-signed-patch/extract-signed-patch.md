# Extract signed patch for P1Monitor

1. Download latest patch [ztatz](https://www.ztatz.nl/p1-monitor-software-archief/)
2. (Optional) create Python virtual environment: `py -m venv {name}-env`
3. (Optional) activate using (PowerShell) `/Scripts/Activate.ps1` or (Bash) `source bin/activate`
4. Install needed package `pip install pynacl`
5. Run script included, `extract-signed-patch.py`, it's a combination of `crypto_lib.py` (containing the needed keys) and `P1Patcher.py`