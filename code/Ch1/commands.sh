# useful conda commands
conda info 
conda upadte conda
conda update anaconda
conda info --envs

# create a new environment using conda
conda create -n py39 python=3.9
conda create -n py39 python=3.9 -y
conda activate py39
conda install pandas=1.4.2
conda deactivate

# clone environment from another environment
conda env create -n py39-new --clone py39

# remove environment
conda env remove -n py39

# create environment from a file
conda env create -f environment.yml

# create environment using venv
python -m venv py3
source py3/bin/activate
pip install pandas==1.4.2
deactivate

# conda create environment and install packages
conda create -n py310 python=3.10 pandas matplotlib -y

# export environment
conda env export -n py310 > environment.yml

# export environment to a file from history
conda env export --from-history > environment.yml
# or if the environment is not active
conda env export --from-history -n py310 > environment.yml

# Jupyter kernelspec list
jupyter kernelspec list

# Jupyter kernelspec install
python -m ipykernel install --user --name=py310 --display-name="Python 3.10"

