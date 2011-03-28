#/bin/bash
PROJECT=`python -c “import os; print os.path.basename(os.getcwd())”`
DJANGO_SETTINGS_MODULE=$PROJECT.settings vim $@
