# Text-to-Speech (TTS) Setup

## Configuring Piper TTS with Speech Dispatcher

This guide covers setting up high-quality neural TTS using Piper instead of the default espeak/festival voices.

### Prerequisites

```bash
# Install required packages (Arch/AUR)
paru -S piper-tts-bin speech-dispatcher

# Optional: Install additional voice packages
paru -S piper-voices-en-us
```

### Installing a Voice

Download a Piper voice (or use the voice packages):

```bash
# Voices are stored in
~/.local/share/piper-voices/

# Example: en_US-amy-medium.onnx and en_US-amy-medium.onnx.json
```

### Configuration

#### 1. Enable the Piper Module

Edit `/etc/speech-dispatcher/speechd.conf`:

```bash
sudo nano /etc/speech-dispatcher/speechd.conf
```

Add this line in the `AddModule` section (around line 290):

```
AddModule "piper-generic" "sd_generic" "piper-generic.conf"
```

Set it as the default module:

```
DefaultModule piper-generic
```

#### 2. Create Piper Module Configuration

Create `/etc/speech-dispatcher/modules/piper-generic.conf`:

```bash
sudo nano /etc/speech-dispatcher/modules/piper-generic.conf
```

Add this configuration (using Ryan high-quality male voice - recommended):

```conf
Debug 0

GenericExecuteSynth "echo '$DATA' | piper-tts --model /usr/share/piper-voices/en/en_US/ryan/high/en_US-ryan-high.onnx --output-raw | paplay --rate=22050 --format=s16le --channels=1 --raw --volume=32768"

GenericCmdDependency "piper-tts"
GenericSoundIconFolder "/usr/share/sounds/sound-icons/"

GenericPunctNone ""
GenericPunctSome "--punct=\"()[]{};:\""
GenericPunctAll "--punct"

GenericRateAdd 0
GenericPitchAdd 0
GenericVolumeAdd 1

GenericRateMultiply 1
GenericPitchMultiply 1
GenericVolumeMultiply 1

AddVoice "en" "MALE1" "ryan-high"
AddVoice "en-us" "MALE1" "ryan-high"

DefaultVoice "ryan-high"
```

**Volume Settings (complete reference - 1% to 100%):**

<details>
<summary>Click to expand full volume table</summary>

- `--volume=655` = 1%
- `--volume=1310` = 2%
- `--volume=1966` = 3%
- `--volume=2621` = 4%
- `--volume=3276` = 5%
- `--volume=3932` = 6%
- `--volume=4587` = 7%
- `--volume=5242` = 8%
- `--volume=5898` = 9%
- `--volume=6553` = 10%
- `--volume=7208` = 11%
- `--volume=7864` = 12%
- `--volume=8519` = 13%
- `--volume=9175` = 14%
- `--volume=9830` = 15%
- `--volume=10485` = 16%
- `--volume=11141` = 17%
- `--volume=11796` = 18%
- `--volume=12451` = 19%
- `--volume=13107` = 20%
- `--volume=13762` = 21%
- `--volume=14417` = 22%
- `--volume=15073` = 23%
- `--volume=15728` = 24%
- `--volume=16384` = 25%
- `--volume=17039` = 26%
- `--volume=17694` = 27%
- `--volume=18350` = 28%
- `--volume=19005` = 29%
- `--volume=19660` = 30%
- `--volume=20316` = 31%
- `--volume=20971` = 32%
- `--volume=21626` = 33%
- `--volume=22282` = 34%
- `--volume=22937` = 35%
- `--volume=23592` = 36%
- `--volume=24248` = 37%
- `--volume=24903` = 38%
- `--volume=25559` = 39%
- `--volume=26214` = 40%
- `--volume=26869` = 41%
- `--volume=27525` = 42%
- `--volume=28180` = 43%
- `--volume=28835` = 44%
- `--volume=29491` = 45%
- `--volume=30146` = 46%
- `--volume=30801` = 47%
- `--volume=31457` = 48%
- `--volume=32112` = 49%
- `--volume=32768` = 50% ⭐ (recommended - comfortable listening level)
- `--volume=33423` = 51%
- `--volume=34078` = 52%
- `--volume=34734` = 53%
- `--volume=35389` = 54%
- `--volume=36044` = 55%
- `--volume=36700` = 56%
- `--volume=37355` = 57%
- `--volume=38010` = 58%
- `--volume=38666` = 59%
- `--volume=39321` = 60%
- `--volume=39976` = 61%
- `--volume=40632` = 62%
- `--volume=41287` = 63%
- `--volume=41943` = 64%
- `--volume=42598` = 65%
- `--volume=43253` = 66%
- `--volume=43909` = 67%
- `--volume=44564` = 68%
- `--volume=45219` = 69%
- `--volume=45875` = 70%
- `--volume=46530` = 71%
- `--volume=47185` = 72%
- `--volume=47841` = 73%
- `--volume=48496` = 74%
- `--volume=49152` = 75%
- `--volume=49807` = 76%
- `--volume=50462` = 77%
- `--volume=51118` = 78%
- `--volume=51773` = 79%
- `--volume=52428` = 80%
- `--volume=53084` = 81%
- `--volume=53739` = 82%
- `--volume=54394` = 83%
- `--volume=55050` = 84%
- `--volume=55705` = 85%
- `--volume=56360` = 86%
- `--volume=57016` = 87%
- `--volume=57671` = 88%
- `--volume=58327` = 89%
- `--volume=58982` = 90%
- `--volume=59637` = 91%
- `--volume=60293` = 92%
- `--volume=60948` = 93%
- `--volume=61603` = 94%
- `--volume=62259` = 95%
- `--volume=62914` = 96%
- `--volume=63569` = 97%
- `--volume=64225` = 98%
- `--volume=64880` = 99%
- `--volume=65536` = 100% (full/default)

</details>

**Note:** This assumes you installed `piper-voices-en-us` package which places voices in `/usr/share/piper-voices/`.

#### 3. Restart Speech Dispatcher

```bash
systemctl --user restart speech-dispatcher
```

#### 4. Test

```bash
spd-say "Testing Piper voice"
```

### Troubleshooting

**Issue: Module not loading**

Check the debug logs:

```bash
systemctl --user stop speech-dispatcher.socket
systemctl --user stop speech-dispatcher
rm -rf /tmp/speechd-debug
speech-dispatcher -D
```

Then check `/tmp/speechd-debug/speech-dispatcher.log` for errors.

**Issue: Wrong piper binary**

Make sure you're using `piper-tts` (the TTS engine) not `piper` (a GTK app for gaming mice):

```bash
which piper-tts  # Should show /usr/bin/piper-tts
piper-tts --version  # Should show version like 1.2.0
```

**Issue: No audio output**

- Ensure `paplay` is installed (part of pulseaudio utilities)
- Test piper directly:
  ```bash
  echo "test" | piper-tts --model ~/.local/share/piper-voices/en_US-amy-medium.onnx --output-file /tmp/test.wav
  paplay /tmp/test.wav
  ```

### Adding More Voices

1. Download additional voice models from [Piper releases](https://github.com/rhasspy/piper/releases)
2. Place `.onnx` and `.onnx.json` files in `~/.local/share/piper-voices/`
3. Add corresponding `AddVoice` entries to the config
4. Update the `GenericExecuteSynth` line to use the new model path, or create separate module configs for different voices

### Voice Quality Levels

Piper voices come in different quality levels:
- **low** - Fastest, lower quality (good for lower-end hardware)
- **medium** - Good balance of quality and speed
- **high** - Best quality, requires more CPU (recommended for modern systems)

### Recommended Voices

**Best Male Voices (High to Low Quality):**

**High Quality (requires modern CPU - Ryzen 7 7800X3D or equivalent recommended):**
1. **ryan-high** ⭐ - Most natural male voice, excellent clarity (116MB)
   - Path: `/usr/share/piper-voices/en/en_US/ryan/high/en_US-ryan-high.onnx`
2. **hfc_male-medium** - Natural high-fidelity male voice
   - Path: `/usr/share/piper-voices/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx`

**Medium Quality (good balance):**
1. **ryan-medium** - Good quality, faster than high
   - Path: `/usr/share/piper-voices/en/en_US/ryan/medium/en_US-ryan-medium.onnx`
2. **joe-medium** - Clear male voice
   - Path: `/usr/share/piper-voices/en/en_US/joe/medium/en_US-joe-medium.onnx`
3. **john-medium** - Professional male voice
   - Path: `/usr/share/piper-voices/en/en_US/john/medium/en_US-john-medium.onnx`

**Low Quality (fastest, lowest CPU usage):**
1. **ryan-low** - Still decent quality, very fast
   - Path: `/usr/share/piper-voices/en/en_US/ryan/low/en_US-ryan-low.onnx`
2. **danny-low** - Fast and lightweight
   - Path: `/usr/share/piper-voices/en/en_US/danny/low/en_US-danny-low.onnx`

**Best Female Voices:**

**High Quality:**
1. **lessac-high** - Professional, natural female voice (109MB)
2. **ljspeech-high** - Classic, clear female voice (109MB)
3. **libritts-high** - Multi-speaker, highest quality (131MB)

**Medium Quality:**
1. **lessac-medium** - Good balance
2. **kristin-medium** - Natural female voice
3. **hfc_female-medium** - High-fidelity female voice

### Testing Voices

Test any voice before switching:

```bash
# Test ryan-high at 50% volume
echo "Hello, I am Ryan" | piper-tts --model /usr/share/piper-voices/en/en_US/ryan/high/en_US-ryan-high.onnx --output-raw | paplay --rate=22050 --format=s16le --channels=1 --raw --volume=32768

# Test lessac-high female voice
echo "Hello, I am Lessac" | piper-tts --model /usr/share/piper-voices/en/en_US/lessac/high/en_US-lessac-high.onnx --output-raw | paplay --rate=22050 --format=s16le --channels=1 --raw --volume=32768
```

### Notes

- The `sd_generic` module requires `AddVoice` declarations to load properly
- Each voice needs both the `.onnx` model file and `.onnx.json` metadata file
- Piper TTS is much higher quality than espeak/festival but requires more CPU
