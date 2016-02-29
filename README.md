# Hacking-a-search-engine
Taking a break.

Experimenting with cython.

https://www.reddit.com/r/dailyprogrammer/comments/47o4b6/20160226_challenge_255_hard_hacking_a_search/


## Usage
Create the virtualenv, install cython, and activate the venv.
```sh
$ virtualenv venv
$ pip install -r requirements.txt
$ source venv/bin/activate
```

Compile the module.
```sh
(venv) $ python setup.py build_ext --inplace
```

Run the script.
```sh
(venv) $ python main.py < sample.txt
```

