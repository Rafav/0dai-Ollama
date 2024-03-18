  GNU nano 7.2                                                                                      0dai.sh                                                                                               
sudo apt update -y && sudo apt upgrade -y
sudo apt install git -y
sudo apt install pip -y
sudo apt install python3-tqdm -y
sudo apt install curl -y 

sudo apt install python3.11-venv -y
sudo apt install python3-tqdm -y



wget https://raw.githubusercontent.com/oobabooga/text-generation-webui/main/download-model.py
python3 download-model.py 0dAI/0dAI-7B
git clone https://github.com/ollama/ollama

curl -fsSL https://ollama.com/install.sh | sh


mv models/0dAI_0dAI-7B/0dAI-00001-of-00003.safetensors models/0dAI_0dAI-7B/model-0dAI-00001-of-00003.safetensors
mv models/0dAI_0dAI-7B/0dAI-00002-of-00003.safetensors models/0dAI_0dAI-7B/model-0dAI-00002-of-00003.safetensors
mv models/0dAI_0dAI-7B/0dAI-00003-of-00003.safetensors models/0dAI_0dAI-7B/model-0dAI-00003-of-00003.safetensors

cd ollama/


git submodule init
git submodule update llm/llama.cpp

python3 -m venv llm/llama.cpp/venv
source llm/llama.cpp/venv/bin/activate

pip install -r llm/llama.cpp/requirements.txt

make -C llm/llama.cpp  quantize

mv ../models/0dAI_0dAI-7B/  .

python3 llm/llama.cpp/convert.py ./0dAI_0dAI-7B/model-0dAI-00001-of-00003.safetensors --outtype f16 --outfile converted.bin
python3 llm/llama.cpp/convert.py ./0dAI_0dAI-7B/model-0dAI-00002-of-00003.safetensors --outtype f16 --outfile converted.bin
python3 llm/llama.cpp/convert.py ./0dAI_0dAI-7B/model-0dAI-00003-of-00003.safetensors --outtype f16 --outfile converted.bin

llm/llama.cpp/quantize converted.bin quantized.bin q4_0

wget https://raw.githubusercontent.com/notluken/notluken.github.io/master/assets/Modelfile
ollama create 0dAI -f Modelfile
