This folder contains the econdings and instances necessary for reproducing the experiments presented in the paper "A Framework for Solving Logic-Based Scheduling Problems in Healthcare"

The folder is structured as follows:
- CTS (a folder containing all the files necessary for the CTS problem experiments)
    - input (a folder containing all the input files)
    - framework_encoding.lp (the file containing the encoding based on our framework)
    - original_encoding.lp (the file containing the original direct encoding)

- ORS (a folder containing all the files necessary for the ORS problem experiments)
    - input (a folder containing all the input files divided by the number of days)
        - days_1 (a folder containing all the input files with 1 day scenario)
        - days_2 (a folder containing all the input files with 2 days scenario)
        - days_3 (a folder containing all the input files with 3 days scenario)
        - days_5 (a folder containing all the input files with 5 days scenario)
    - framework_encoding.lp (the file containing the encoding based on our framework)
    - original_encoding.lp (the file containing the original direct encoding)

# Setup
CLINGO is required to run the experiments. You can follow the installation guide here:
https://github.com/potassco/clingo/blob/master/INSTALL.md

You also need the python dependency:

```pip install clingo```

# CTS

In order to run the framework approach:
```
python3 CTS/run.py CTS/input/input{i}.lp
```
where i goes from 1 to 4.

Running direct encoding:
```
clingo CTS/original_encoding.lp CTS/input/input{i}.lp --time-limit=200
```
where i goes from 1 to 4.


# ORS
Running framework approach:
```
python3 ORS/run.py ORS/input/days_{d}/input{i}.lp
```
where:
- d is one of 1, 2, 3, 5
- i goes from 1 to 10

Running direct encoding:
```
clingo ORS/original_encoding.lp ORS/input/days_{d}/input{i}.lp --time-limit=300
```
where:
- d is one of 1, 2, 3, 5
- i goes from 1 to 10