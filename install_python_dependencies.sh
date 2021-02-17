#!/bin/bash

pip install -r requirements.txt
python -m spacy download en_core_web_sm
python download_benepar_model.py