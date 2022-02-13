#!/bin/bash
pip3 install -r requirements.txt -r requirements-test.txt
python -m unittest discover -s tests/
coverage run -m unittest discover -s tests/
coverage report --include crawler/crawler.py > output/test/crawler_report.txt