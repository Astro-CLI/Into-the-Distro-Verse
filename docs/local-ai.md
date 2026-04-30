<!-- 
    WIKI GUIDE: local-ai.md
    Guide for setting up local Large Language Models (LLMs) on Arch Linux,
    optimized for AMD hardware using ROCm. Includes Ollama, Open Interpreter,
    and helper scripts for easy model management.
-->

### Running Local AI Models: Your Personal ChatGPT

Want AI tools that don't phone home to big corporations? This guide shows how to run powerful language models entirely on your own hardware using Ollama. Everything stays private, runs fast, and never leaves your computer.

---

## 🤔 Why Run AI Locally?

- **Privacy** - No data sent to corporations or cloud servers
- **Speed** - No network latency, instant responses
- **Cost** - No API fees or subscription charges
- **Control** - Use exactly the models you want
- **Offline** - Works without internet connection
- **Learning** - Understand how AI actually works

---

## ⚙️ Your Hardware Matters

This guide assumes:
- **GPU:** AMD Radeon RX 7600 XT (16GB VRAM)
- **CPU:** AMD Ryzen 7 7800X3D
- **RAM:** 32GB DDR5
- **Driver:** ROCm (AMD's compute platform)

With 16GB VRAM, you can run models up to 20B parameters smoothly.

---

## 🧠 1. Setting Up Ollama (The Brain)

Ollama is the backend engine that runs your models locally.

### Option A: Native Installation (Recommended)

Native installation gives the best performance:

```bash
sudo pacman -S ollama-rocm
sudo systemctl enable --now ollama.service
```

### Option B: Docker Setup

If you want isolation or have multiple versions:

```bash
docker run -d \
  --device /dev/kfd --device /dev/dri \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --name ollama \
  ollama/ollama:rocm
```

(GPU access works by mapping device files `/dev/kfd` and `/dev/dri`)

---

## 🎛️ 2. Managing Models with the `ai` Script

We've created a helper script that makes model selection super easy. It's an interactive menu that:

- **Categorizes models** by size (Large, Medium, Small)
- **Remembers your choice** - just press Enter to use the same model
- **Clears VRAM instantly** with option 0
- **Ranks models** by quality within each category

### Using the AI Manager

```bash
ai
```

You'll see a menu of available models. Select one and it launches instantly.

---

## 🤖 3. Open Interpreter: AI With Hands

Open Interpreter lets AI help with system tasks - it can run terminal commands, write scripts, and explore your files (with your permission).

### Installation

```bash
### Create a virtual environment
python -m venv ~/interpreter_env
~/interpreter_env/bin/pip install open-interpreter setuptools

### If Python 3.14+, add compatibility shim:
cat > ~/interpreter_env/lib/python3.14/site-packages/pkg_resources.py << 'COMPAT'
import importlib.metadata
def get_distribution(name):
    return importlib.metadata.distribution(name)
COMPAT
```

### Using Open Interpreter

```bash
### Normal mode (with internet access for web tasks)
~/interpreter_env/bin/interpreter --local --api_base http://localhost:11434

### Offline mode (no internet, complete privacy)
~/interpreter_env/bin/interpreter --local --api_base http://localhost:11434 --offline
```

### Example Commands

```
"List the 5 largest files in my Downloads folder"
"Help me organize my photos by date"
"Check my GPU temperatures using rocm-smi"
```

---

## 🔒 4. Security: Internet Kill-Switch

For sensitive work, run AI in an offline sandbox using firejail:

```bash
firejail --net=none ~/interpreter_env/bin/interpreter --local --api_base http://localhost:11434
```

The AI can still talk to Ollama locally, but can't reach the internet.

---

## 📊 5. Recommended Models for 16GB VRAM

| Tier | Model | Best For | VRAM | Speed |
|------|-------|----------|------|-------|
| **Large** | `qwen2.5-coder:14b` | 🏆 System commands | 9GB | Fast |
| **Large** | `gemma2:27b` | Reasoning & analysis | 16GB+ | Moderate |
| **Medium** | `gemma2:9b` | 🏆 General chat | 6GB | Fast |
| **Medium** | `llama3.1:latest` | Reliable general use | 5GB | Fast |
| **Small** | `qwen2.5:3b` | Quick summaries | 2GB | Very fast |

**Pro tip:** `qwen2.5-coder:14b` is excellent for system administration tasks.

---

## 🛠️ 6. Helper Scripts

Two scripts make everything easy:

### Script 1: Model Manager (`/usr/local/bin/ai`)

Interactive menu for launching models and freeing VRAM.

### Script 2: Interpreter Wrapper (`/usr/local/bin/interpreter`)

Simplifies launching Open Interpreter with the correct settings.

Both scripts are self-contained and ready to use.

---

## 📈 7. Monitoring & Maintenance

### Check VRAM Usage

```bash
rocm-smi
```

### List All Models

```bash
ollama list
```

### Free VRAM Immediately

```bash
ai
### Select option 0
```

### Model Storage

Models are stored in:
- Native: `/usr/share/ollama/.ollama`
- Docker: Docker volume (managed automatically)

---

## ⚡ Tips for Best Performance

- **Start with Medium models** - balances quality and speed
- **Use BFQ I/O scheduler** - prevents system slowdowns
- **Monitor temps** - AI models can heat your GPU
- **Close unnecessary apps** - free up RAM for the model
- **Use offline mode** for sensitive work

---

## 🎯 Why Would I Use This?

- **Privacy-first AI** - No data goes to cloud
- **Fast responses** - Local processing = instant answers
- **Offline AI** - Works without internet
- **Cost savings** - One-time hardware investment
- **Learning** - Understand how models actually work
- **System automation** - Let AI help with tasks

---

## 🔗 Related Guides

- 📖 **[Audio & Video Production](audio-video.md)** - For combining AI with media
- 📖 **[System Maintenance](system_maintenance.md)** - Keeping your system optimized
- 📖 **[Security Hardening](security.md)** - Sandbox AI for maximum privacy
- 📖 **[Arch Linux Guide](arch.md)** - Package management
