# Python

## Saving Environment
* ```environment.yml``` format
```bash
conda env export --no-builds | grep -v "prefix" > environment.yml
```

* ```requirements.txt``` format
```bash
pip list --format=freeze > requirements.txt
```
