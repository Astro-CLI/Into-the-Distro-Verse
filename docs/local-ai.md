# Local AI & LLM Setup

This guide documents the setup of local Large Language Models (LLMs) on Arch Linux, optimized for AMD hardware (ROCm).

## Hardware Context
- **GPU:** AMD Radeon RX 7600 XT (16GB VRAM)
- **CPU:** AMD Ryzen 7 7800X3D
- **RAM:** 32GB DDR5
- **Driver Stack:** ROCm (Radeon Open Compute)

The 16GB of VRAM allows for running models up to 14B-20B parameters entirely on the GPU at high speeds.

---

## 1. Core Engine: Ollama

Ollama serves as the backend "brain." While native installation is recommended on Arch, Docker is a viable alternative for isolation.

### Option A: Native Installation (Recommended)
Native installation provides the best performance and easiest integration with host-side tools.
```bash
sudo pacman -S ollama-rocm
sudo systemctl enable --now ollama.service
```

### Option B: Docker-based Setup
Useful for isolating the LLM environment or running multiple versions.
```bash
docker run -d \
  --device /dev/kfd --device /dev/dri \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --name ollama \
  ollama/ollama:rocm
```
*Note: GPU access is enabled by mapping `/dev/kfd` and `/dev/dri` device files.*

---

## 2. Manager Script: `ai`

A portable Bash script located at `/usr/local/bin/ai` that provides an interactive menu to manage and launch models.

### Key Features
- **Categorization:** Models are sorted into Large (14B), Medium (7B-8B), and Small (3B).
- **Ranking:** Prioritizes specialist models (like Qwen Coder) at the top of their categories.
- **Instant Unload:** Press `0` to instantly clear VRAM (useful before launching heavy games).
- **Persistence:** Remembers your last choice; just press `Enter` to resume the previous session.

---

## 3. System Agent: Open Interpreter

Open Interpreter provides the "hands" for the AI, allowing it to run terminal commands and python scripts with your approval.

### Setup (Python 3.14+ "Monkey-Patch")
Newer Python versions (3.14+) have removed the legacy `pkg_resources` module. We install it in a virtual environment and apply a compatibility patch.

1. **Create Environment:**
   ```bash
   python -m venv ~/interpreter_env
   ~/interpreter_env/bin/pip install open-interpreter setuptools
   ```

2. **Apply Patch:** Create `~/interpreter_env/lib/python3.14/site-packages/pkg_resources.py`:
   ```python
   import importlib.metadata
   def get_distribution(name):
       return importlib.metadata.distribution(name)
   ```

3. **Usage Command:**
   Point it to your local Ollama instance:
   ```bash
   ~/interpreter_env/bin/interpreter --local --api_base http://localhost:11434 --model ollama/qwen2.5-coder:14b
   ```

### Command Examples
- *"List the 5 largest files in my Downloads folder."*
- *"Help me find all my .pkt files and move them to a new folder."*
- *"Check my current GPU temperatures using rocm-smi."*

---

## 4. Security: The Internet Kill-Switch

For sensitive tasks, you can run the AI in a fully offline sandbox using `firejail`. It will still be able to "talk" to your local Ollama brain, but cannot reach the internet.

```bash
firejail --net=none ~/interpreter_env/bin/interpreter --local --api_base http://localhost:11434
```

---

## 5. Helper Scripts

To make usage simple, the following scripts were created to automate model management and tool integration.

### The `ai` Model Manager
**Location:** `/usr/local/bin/ai` (Executable)

This script provides an interactive menu for selecting and launching models, as well as clearing VRAM.

```bash
#!/usr/bin/env bash

# Paths for last used model
CACHE_DIR="$HOME/.cache"
LAST_MODEL_FILE="$CACHE_DIR/ai_last_model"
mkdir -p "$CACHE_DIR"

# Define our ideal ranking order (Best to Worst in each category)
LARGE_RANK=(
    "qwen2.5-coder:14b"
    "phi4:latest"
    "deepseek-r1:14b"
    "gemma2:27b"
)

MEDIUM_RANK=(
    "gemma2:9b"
    "llama3.1:latest"
    "qwen2.5-coder:7b"
    "mistral:latest"
    "deepseek-r1:7b"
)

SMALL_RANK=(
    "qwen2.5:3b"
    "llama3.2:latest"
    "gemma2:2b"
)

# Get current models from ollama
mapfile -t current_models < <(ollama list | tail -n +2 | awk '{print $1}')

# Function to check if a model exists in current_models
model_exists() {
    local target="$1"
    for m in "${current_models[@]}"; do
        if [ "$m" == "$target" ]; then return 0; fi
    done
    return 1
}

# Load last used model
last_model=""
if [ -f "$LAST_MODEL_FILE" ]; then
    last_model=$(cat "$LAST_MODEL_FILE")
fi

echo "--- Local AI Manager ---"
printf "[0] 🧊 Unload All Models (Free VRAM)\n"

menu_items=()
counter=1

# Print Categories
print_category() {
    local header="$1"
    shift
    local rank_array=("$@")
    local found_any=0
    
    for model in "${rank_array[@]}"; do
        if model_exists "$model"; then
            if [ $found_any -eq 0 ]; then
                printf "\n\e[1;34m%s\e[0m\n" "$header"
                found_any=1
            fi
            mark="  "
            if [ "$model" == "$last_model" ]; then
                mark="* "
            fi
            printf "[%d] %s%s\n" "$counter" "$mark" "$model"
            menu_items+=("$model")
            counter=$((counter + 1))
        fi
    done
}

print_category "--- LARGE MODELS (High IQ / 14B) ---" "${LARGE_RANK[@]}"
print_category "--- MEDIUM MODELS (Balanced / 7B-8B) ---" "${MEDIUM_RANK[@]}"
print_category "--- SMALL MODELS (Fast / 3B) ---" "${SMALL_RANK[@]}"

# Catch any models not in our list
others=()
for m in "${current_models[@]}"; do
    is_ranked=0
    for r in "${LARGE_RANK[@]}" "${MEDIUM_RANK[@]}" "${SMALL_RANK[@]}"; do
        if [ "$m" == "$r" ]; then is_ranked=1; break; fi
    done
    if [ $is_ranked -eq 0 ]; then others+=("$m"); fi
done
if [ ${#others[@]} -gt 0 ]; then
    print_category "--- OTHER MODELS ---" "${others[@]}"
fi

echo ""
if [ -n "$last_model" ]; then
    read -p "Select model (default: $last_model) [0-$((counter-1))]: " choice
else
    read -p "Select model [0-$((counter-1))]: " choice
fi

# Selection Logic
selected_model=""
if [ -z "$choice" ]; then
    selected_model="$last_model"
elif [ "$choice" == "0" ]; then
    echo "🧊 Unloading from VRAM..."
    curl -s -X POST http://localhost:11434/api/generate -d "{\"model\": \"$last_model\", \"keep_alive\": 0}" > /dev/null
    echo "✅ VRAM cleared!"
    exit 0
elif [[ "$choice" =~ ^[0-9]+$ ]]; then
    if [ "$choice" -ge 1 ] && [ "$choice" -le "${#menu_items[@]}" ]; then
        selected_model="${menu_items[$((choice - 1))]}"
    else
        echo "❌ Invalid selection."
        exit 1
    fi
else
    echo "❌ Invalid input."
    exit 1
fi

# Run the model
if [ -n "$selected_model" ]; then
    echo "$selected_model" > "$LAST_MODEL_FILE"
    echo "🚀 Launching $selected_model..."
    ollama run "$selected_model"
fi
```

### The `interpreter` Shortcut (Portable Bash)
**Location:** `/usr/local/bin/interpreter` (Executable)

This script simplifies launching Open Interpreter, handles Python 3.14 compatibility, and adds a privacy toggle.

```bash
#!/usr/bin/env bash
export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
INTERPRETER_BIN="$HOME/interpreter_env/bin/interpreter"
CMD="$INTERPRETER_BIN --local --api_base http://localhost:11434"

# Handle --offline flag
if [[ "$*" == *"--offline"* ]]; then
    echo "🔒 Running in OFFLINE mode (Internet Disabled)"
    firejail --net=none --quiet bash -c "$CMD ${*//--offline/}"
else
    bash -c "$CMD $*"
fi
```

---

## 6. Live Information & Internet Access

While the LLM "brain" (Ollama) is offline, Open Interpreter can access the internet using host-side tools.

### How to use Internet
1. Run the command without the offline flag: `interpreter`.
2. Ask the AI to perform a web-based task:
   - *"Find the current price of Bitcoin."*
   - *"Search the web for the latest Arch Linux news."*

The AI will write and execute Python code (using libraries like `requests` or `selenium`) to fetch the data and present it to you.

---

## 7. Recommended Models for 16GB VRAM

| Tier | Recommended Model | Best For... | VRAM Usage |
| :--- | :--- | :--- | :--- |
| **Large** | `gemma2:27b` | **Google's Best:** High Reasoning | ~16GB+ |
| **Large** | `qwen2.5-coder:14b` | **Top Pick:** Best for System Commands | ~9GB |
| **Large** | `phi4:latest` | Logic, Math, Reasoning | ~9GB |
| **Large** | `deepseek-r1:14b` | Deep Thinking (Reasoning) | ~9GB |
| **Medium** | `gemma2:9b` | **Generalist King:** Great Chat/Creative | ~6GB |
| **Medium** | `llama3.1:latest` | General Chat & Reliability | ~5GB |
| **Medium** | `qwen2.5-coder:7b` | Coding & Scripting | ~5GB |
| **Small** | `qwen2.5:3b` | Instant Summaries / Low Resource | ~2GB |
| **Small** | `gemma2:2b` | Blazing Fast Basic Tasks | ~1.5GB |

---

## 8. Maintenance & Performance
- **Monitor VRAM:** Run `rocm-smi` to see real-time allocation.
- **Clear Memory:** Use the `ai` command and select `0` to free up GPU space immediately.
- **Disk Usage:** Models are stored in `/usr/share/ollama/.ollama` (Native) or Docker volumes.
