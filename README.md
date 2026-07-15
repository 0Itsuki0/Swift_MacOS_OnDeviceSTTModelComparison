# Swift_MacOS_OnDeviceSTTModelComparison

A comparison of on device models (specifically, whisper family and qwen3 ASR
family) when actually running locally on device.

For more details, please refer to my blog [Swift/MacOS OnDevice STT. Which Model To Choose?](https://medium.com/@itsuki.enjoy/swift-macos-ondevice-stt-which-model-to-choose-mlx-d0478e52be3d)


| Model                             |                 Approx. Time | English    | Japanese   | Mixed Language | Stability  | Overall Notes                                                                                                                                                                                                                                |
| --------------------------------- | ---------------------------: | ---------- | ---------- | -------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Whisper Large V3 Turbo**        |               **~1.5–3.1 s** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐☆  | ⭐⭐⭐⭐⭐     | ⭐⭐⭐⭐⭐ | Most reliable overall. Excellent language auto-detection. Japanese punctuation is sparse but transcript is accurate. Correctly recognized **Itsuki**.                                                                                        |
| **Qwen3-ASR 1.7B (BF16 / 6-bit)** |               **~2.8–5.0 s** | ⭐⭐⭐☆    | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐     | ⭐⭐⭐⭐⭐ | Excellent Japanese punctuation. English occasionally inserts filler words ("Um") and misspells names (Itsuki → Itzky). Quantization has minimal effect on speed or quality.                                                                  |
| **Qwen3-ASR 0.6B (4/6/8-bit)**    |               **~2.7–4.8 s** | ⭐⭐⭐☆    | ⭐⭐⭐⭐☆  | ⭐⭐⭐⭐⭐     | ⭐⭐⭐⭐⭐ | Surprisingly close to 1.7B in both latency and quality. Occasionally adds fillers ("え", "Um") or small recognition errors.                                                                                                                  |
| **Whisper Medium**                | **~2.0–3.0 s (or unstable)** | ❓         | ❓         | ❓             | ⭐         | Unstable in MLX Swift Audio. Observed empty output, Korean output, English translation of Japanese, and other inconsistent behavior. Not trustworthy for production.                                                                         |
| **Whisper Small**                 |               **~1.6–7.3 s** | ❓         | ❓         | ❓             | ⭐         | Extremely unstable. Sometimes perfect, sometimes outputs a single word, sometimes enters repetition loops ("I I I...", "to to to..."), sometimes translates Japanese into English. Runtime varies dramatically depending on decoder failure. |

- ❓: Unstable
- Approx. Time is for ~5 seconds audio
- Always using nil for the language parameter, ie: having the model to
  auto-detect.
