#!/usr/bin/bash

# If the user isn't root do not run the script 

if [ "$EUID" -ne 0 ]; then
	echo "[!] Run this script as root."
	exit 1
fi

# Full upgrade. BECAREFUL. If you're on Parrot OS, comment this line and do a 'sudo parrot-upgrade'

apt update -y && sudo apt upgrade -y

# Installing dependencies

apt install git pip python3-tqdm curl python3.11-venv -y

# Downloader of 0dAI

wget https://raw.githubusercontent.com/oobabooga/text-generation-webui/main/download-model.py

# Downloading 0dAI

python3 download-model.py 0dAI/0dAI-7B

# Downloading Ollama Repo

git clone https://github.com/ollama/ollama

# Downloading Ollama binary

curl -fsSL https://ollama.com/install.sh | sh

# Renaming the model

for i in $(seq 1 3)
do
	mv models/0dAI_0dAI-7B/0dAI-0000$i-of-00003.safetensors models/0dAI_0dAI-7B/model-0000$i-of-00003.safetensors 
done

cd ollama/

# Updating the submodule of Llama.cpp

git submodule init
git submodule update llm/llama.cpp

# Creating the Virtual enviroment (venv)

python3 -m venv llm/llama.cpp/venv
source llm/llama.cpp/venv/bin/activate

pip install -r llm/llama.cpp/requirements.txt

# Making the quantizer tool

make -C llm/llama.cpp  quantize

mv ../models/0dAI_0dAI-7B/  .

# Converting the 0dAI model to one which Ollama can Understand

python3 llm/llama.cpp/convert.py ./0dAI_0dAI-7B --outtype f16 --outfile converted.bin

# Quantizing the model

llm/llama.cpp/quantize converted.bin quantized.bin q4_0

# Downloading the Modelfile

wget https://raw.githubusercontent.com/notluken/notluken.github.io/master/assets/Modelfile

# Creating the model

ollama create 0dAI -f Modelfile


echo "[+] Installation finished. Run ollama run 0dAI to use 0dAI."
