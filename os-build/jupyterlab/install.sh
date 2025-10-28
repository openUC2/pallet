#!/bin/bash

echo "=== Updating system and installing dependencies ==="
sudo apt update
sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-dev libatlas-base-dev libffi-dev libssl-dev libzmq3-dev

echo "=== Installing Jupyter Notebook ==="
pip3 install --upgrade pip
pip3 install jupyter

echo "=== Generating Jupyter config ==="
jupyter notebook --generate-config

echo "=== Setting up Jupyter password ==="
HASHED_PASS=$(python3 -c "from notebook.auth import passwd; print(passwd())")
echo "c.NotebookApp.password = u'$HASHED_PASS'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py

echo "=== Creating systemd service ==="
cat <<EOF | sudo tee /etc/systemd/system/jupyter-notebook.service
[Unit]
Description=Jupyter Notebook
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi
ExecStart=/usr/bin/jupyter-notebook
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "=== Enabling and starting service ==="
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable jupyter-notebook
sudo systemctl start jupyter-notebook

echo "=== Done ==="
echo "Access it at: http://<your-pi-ip>:8888 (password protected)"
