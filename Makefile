.PHONY: build-odes install-conda install-odes

build-odes:
	conda config --add channels logicabrity
	conda build odes

install-conda:
	wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda.sh;
	bash ./miniconda.sh -b -p $$HOME/miniconda
	conda install --yes conda-build
	conda upgrade --yes conda conda-build

install-odes:
	conda install --yes --use-local odes
