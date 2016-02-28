#!/usr/bin/env sh

MODULE=$1
if [ -z $MODULE ]
then
    echo "module not provided"
    exit 1
fi
python setup.py build_ext --inplace

if [ $? != 0 ]
then
    exit 1
fi
python -c "import $MODULE"

