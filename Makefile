SHELL := /bin/bash

# Version of Python to use is set via TRAVIS_PYTHON_VERSION or PYTHON.
# TRAVIS_PYTHON_VERSION takes precedence.
# Example:
#     PYTHON=3.4 make build-odes
# Default value is 2.7.

ifdef TRAVIS_PYTHON_VERSION
	PYTHON = $(TRAVIS_PYTHON_VERSION)
endif
PYTHON ?= 2.7
export PYTHON

# Two different versions of Conda exist. One for Python 2 and one for Python 3.

ifeq ($(PYTHON),2.7)
	MINICONDA="Miniconda"
else
	MINICONDA="Miniconda3"
endif

build-odes:
	conda config --add channels logicabrity 
	conda config --add channels cyclus
	CONDA_PY=$${PYTHON//.} conda build --quiet --python $(PYTHON) odes

create-environment:
	conda create --quiet --yes --name p$(PYTHON) python=$(PYTHON)
	@echo You need to activate this environment via `source activate p$(PYTHON)`.
	@echo This can't be done via this Makefile.

handle-python-version:
# We don't need to install the package enum34 for python >= 3.4.
# However, we can't express that in the Conda recipe itself, so
# we patch the meta.yaml file.
	@if [[ ($(PYTHON) == "3.4") || ($(PYTHON) > "3.4") ]]; then \
		sed -i 's/\- enum34/\# enum34 \# deactivated for python \>\= 3\.4/g' odes/meta.yaml; \
	fi

# We also want to control the environment Conda creates.
	@sed -i "s/\- python.*/\- python $(PYTHON)\*/g" odes/meta.yaml
	@echo Done.

install-conda:
	wget https://repo.continuum.io/miniconda/$(MINICONDA)-latest-Linux-x86_64.sh -O miniconda.sh;
	bash ./miniconda.sh -b -p $$HOME/miniconda
	conda install --quiet --yes conda-build
	conda upgrade --quiet --yes conda conda-build

install-odes:
	conda install --yes --use-local odes

.PHONY: build-odes create-environment handle-python-version install-conda install-odes
