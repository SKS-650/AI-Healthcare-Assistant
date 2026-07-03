"""
Train disease prediction model from emergency_cases.csv dataset.

Dataset: datasets/emergency/emergency_cases.csv
Format: index, label, text (patient symptom description → disease label)
Classes: 24 disease categories, 1200 samples (50 per class)

Model: TF-IDF (unigram + bigram) + Logistic Regression pipeline
Artifacts saved to: ai_models/saved_models/
"""

from __future__ import annotations

import hashlib
import json
import os
import sys

import numpy as np
import pandas as pd
from joblib import dump
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix,
)
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.pipeline import Pipeline


# ── Paths ────────────────────────────────────────────────────────────────────
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DATASET_PATH = os.path.join(ROOT, "datasets", "emergency", "emergency_cases.csv")
OUT_DIR = os.path.join(ROOT, "ai_models", "saved_models")
MODEL_PATH = os.path.join(OUT_DIR, "disease_model.joblib")
ARTIFACTS_PATH = os.path.join(OUT_DIR, "disease_artifacts.json")
LABEL_MAP_PATH = os.path.join(OUT_DIR, "label_map.json")


def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def clean_text(text: str) -> str:
    """Basic text normalisation: lowercase and collapse whitespace."""
    import re
    text = str(text).lower().strip()
    text = re.sub(r"\s+", " ", text)
    # Remove non-ascii but keep spaces and standard punctuation
    text = re.sub(r"[^a-z0-9\s.,!?'-]", " ", text)
    return text


def main() -> None:
    os.makedirs(OUT_DIR, exist_ok=True)

    # ── Load data ─────────────────────────────────────────────────────────────
    print(f"[INFO] Loading dataset: {DATASET_PATH}")
    df = pd.read_csv(DATASET_PATH)

    if "label" not in df.columns or "text" not in df.columns:
        print("[ERROR] Expected 'label' and 'text' columns.")
        sys.exit(1)

    df = df.dropna(subset=["label", "text"])
    df["text_clean"] = df["text"].apply(clean_text)
    df["label"] = df["label"].str.strip()

    X = df["text_clean"].tolist()
    y = df["label"].tolist()

    labels = sorted(set(y))
    label_to_id = {lbl: i for i, lbl in enumerate(labels)}
    id_to_label = {i: lbl for lbl, i in label_to_id.items()}

    print(f"[INFO] Dataset: {len(X)} samples, {len(labels)} classes")
    print(f"[INFO] Classes: {labels}")

    # ── Train / test split ────────────────────────────────────────────────────
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )
    print(f"[INFO] Train: {len(X_train)}, Test: {len(X_test)}")

    # ── Model pipeline ────────────────────────────────────────────────────────
    pipe = Pipeline(
        [
            (
                "tfidf",
                TfidfVectorizer(
                    ngram_range=(1, 3),
                    max_features=80_000,
                    sublinear_tf=True,
                    min_df=2,
                    analyzer="word",
                ),
            ),
            (
                "clf",
                LogisticRegression(
                    max_iter=500,
                    C=5.0,
                    solver="lbfgs",
                    n_jobs=-1,
                    random_state=42,
                ),
            ),
        ]
    )

    # ── Train ─────────────────────────────────────────────────────────────────
    print("[INFO] Training model …")
    pipe.fit(X_train, y_train)

    # ── Evaluate ──────────────────────────────────────────────────────────────
    y_pred = pipe.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    report = classification_report(y_test, y_pred, output_dict=True)
    print(f"[INFO] Test accuracy: {acc:.4f}")
    print(classification_report(y_test, y_pred))

    # Cross-validation
    cv_scores = cross_val_score(pipe, X, y, cv=5, scoring="accuracy", n_jobs=-1)
    print(f"[INFO] 5-fold CV accuracy: {cv_scores.mean():.4f} ± {cv_scores.std():.4f}")

    # ── Save model ────────────────────────────────────────────────────────────
    dump(pipe, MODEL_PATH)
    print(f"[INFO] Model saved: {MODEL_PATH}")

    # Save label map
    with open(LABEL_MAP_PATH, "w", encoding="utf-8") as f:
        json.dump({"id_to_label": id_to_label, "label_to_id": label_to_id}, f, indent=2)
    print(f"[INFO] Label map saved: {LABEL_MAP_PATH}")

    # ── Artifacts ─────────────────────────────────────────────────────────────
    per_class_f1 = {
        cls: round(report[cls]["f1-score"], 4)
        for cls in labels
        if cls in report
    }
    artifacts = {
        "method": "tfidf_logreg",
        "version": "2.0",
        "model": {"file": "disease_model.joblib"},
        "label_map": "label_map.json",
        "meta": {
            "num_samples": len(X),
            "num_classes": len(labels),
            "labels": labels,
            "train_size": len(X_train),
            "test_size": len(X_test),
            "test_accuracy": round(acc, 4),
            "cv_accuracy_mean": round(float(cv_scores.mean()), 4),
            "cv_accuracy_std": round(float(cv_scores.std()), 4),
            "per_class_f1": per_class_f1,
        },
        "dataset": {
            "path": DATASET_PATH,
            "sha256": sha256_file(DATASET_PATH),
        },
        "preprocessing": {
            "vectorizer": "TfidfVectorizer(ngram_range=(1,3), max_features=80000, sublinear_tf=True)",
            "classifier": "LogisticRegression(C=5.0, max_iter=500)",
        },
    }
    with open(ARTIFACTS_PATH, "w", encoding="utf-8") as f:
        json.dump(artifacts, f, indent=2)
    print(f"[INFO] Artifacts saved: {ARTIFACTS_PATH}")
    print(f"\n✅ Training complete. Accuracy: {acc:.2%}")


if __name__ == "__main__":
    main()
