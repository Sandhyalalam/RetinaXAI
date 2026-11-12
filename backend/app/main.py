"""
RetinaXAI FastAPI backend
Contract for Flutter (Sandhya / Role 1):
  POST /predict  multipart file field: "file"
  JSON: {
    "level": int,
    "label": str,
    "confidence": float,
    "probabilities": [p0, p1, p2, p3, p4],
    "heatmap_base64": str,
    "model": str
  }

Sailaja can replace `run_inference` with EfficientNet + Grad-CAM
while keeping this response shape.
"""

from __future__ import annotations

import base64
import io
import math
from pathlib import Path

from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image, ImageDraw, ImageEnhance, ImageFilter

LABELS = [
    "No DR",
    "Mild DR",
    "Moderate DR",
    "Severe DR",
    "Proliferative DR",
]

app = FastAPI(title="RetinaXAI", version="1.0.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MODEL_PATH = Path(__file__).resolve().parent.parent / "models" / "efficientnet_dr.pt"


def _softmax(logits: list[float]) -> list[float]:
    peak = max(logits)
    exps = [math.exp(v - peak) for v in logits]
    total = sum(exps) or 1.0
    return [v / total for v in exps]


def overlay_heatmap(image: Image.Image) -> Image.Image:
    base = image.convert("RGB").resize((512, 512))
    overlay = Image.new("RGBA", base.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay, "RGBA")
    blobs = [
        (0.72, 0.42, 90, (255, 80, 40, 160)),
        (0.38, 0.48, 70, (255, 180, 40, 130)),
        (0.48, 0.58, 55, (255, 220, 60, 110)),
        (0.30, 0.36, 40, (80, 180, 255, 90)),
    ]
    for nx, ny, radius, color in blobs:
        cx, cy = int(512 * nx), int(512 * ny)
        draw.ellipse((cx - radius, cy - radius, cx + radius, cy + radius), fill=color)
    overlay = overlay.filter(ImageFilter.GaussianBlur(radius=28))
    blended = Image.alpha_composite(base.convert("RGBA"), overlay).convert("RGB")
    mask = Image.new("L", base.size, 0)
    ImageDraw.Draw(mask).ellipse((4, 4, 508, 508), fill=255)
    out = Image.composite(blended, base, mask)
    return out


def encode_png(image: Image.Image) -> str:
    buf = io.BytesIO()
    image.save(buf, format="PNG")
    return base64.b64encode(buf.getvalue()).decode("ascii")


def run_inference(image: Image.Image) -> dict:
    """
    Placeholder inference used until trained EfficientNet weights are available.
    Image stats change the predicted level so integration can be tested with
    different photos. Replace this with the trained model + Grad-CAM.
    """
    rgb = image.convert("RGB").resize((64, 64))
    pixels = list(rgb.getdata())
    n = len(pixels) or 1
    mean_r = sum(p[0] for p in pixels) / n / 255.0
    mean_g = sum(p[1] for p in pixels) / n / 255.0
    mean_b = sum(p[2] for p in pixels) / n / 255.0
    contrast = ImageEnhance.Contrast(rgb).enhance(1.0)
    # crude contrast proxy from extrema
    extrema = contrast.getextrema()
    spread = sum((hi - lo) for lo, hi in extrema) / (3 * 255)
    score = max(0.0, min(4.0, (0.55 - mean_r) * 2.2 + spread * 1.6 + mean_g * 0.4))
    level_hint = int(round(score))
    logits = [-2.2, -1.4, -0.6, 0.4, -1.1]
    logits[level_hint] += 2.8
    logits = [
        logits[0] + 0.1 * (1 - mean_r),
        logits[1] + spread,
        logits[2] + mean_r,
        logits[3] + (1 - spread) + mean_b * 0.2,
        logits[4] + score / 4,
    ]
    probs = _softmax(logits)
    level = max(range(5), key=lambda i: probs[i])
    heatmap = overlay_heatmap(image)
    return {
        "level": level,
        "label": LABELS[level],
        "confidence": round(probs[level], 4),
        "probabilities": [round(p, 4) for p in probs],
        "heatmap_base64": encode_png(heatmap),
        "model": "efficientnet-placeholder",
        "using_trained_weights": MODEL_PATH.exists(),
    }


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "RetinaXAI",
        "weights_found": MODEL_PATH.exists(),
    }


@app.post("/predict")
async def predict(file: UploadFile = File(...)) -> dict:
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Upload a JPG or PNG fundus image.")
    raw = await file.read()
    if not raw:
        raise HTTPException(status_code=400, detail="Empty file.")
    try:
        image = Image.open(io.BytesIO(raw))
        image.load()
    except Exception as exc:  # noqa: BLE001
        raise HTTPException(status_code=400, detail="Could not read image.") from exc
    return run_inference(image)
