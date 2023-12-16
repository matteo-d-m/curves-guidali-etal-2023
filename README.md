## Psychometric curve fitting ##

This repository contains a personal copy of Matlab code written for [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) and already published on the Open Science Framework (OSF) at [this HTTPS URL](https://osf.io/6mypr/) (`Task and script\PSE script`). 

Broadly speaking, this code preprocesses behavioural data from a computerized landmark task (LM), fits psychometric curves to them, and plots them. Please refer to either [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) or the associated OSF project page for further details. 

---

The code is organized as follows:
- `Dependencies` is a folder containing Matlab code files (`.m`) with functions to:
    - Preprocess LM data
    - Compute LM's dependent variables 
    - Fit psychometric curves
    - Draw and display psychometric curves
- `fit_psyfunc_ccpas_master.m` calls the functions contained by `Dependencies`, in the right order

Running `fit_psyfunc_ccpas_master.m` is enough to reproduce the results described by [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216). Raw data can be found on the [OSF](https://osf.io/6mypr/). 

Please preserve the current directory structure to minimize the risk of code breaking. 

Note that: 
- The code in this repository is just my personal copy of the one published on the [OSF](https://osf.io/6mypr/). The official archive of supplementary materials (including code) for [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) is the one on OSF
- The code in this repository can be reused under the terms described by the original license (CC-BY-4.0 - check on OSF). Should you reuse this code in published work, please cite the scientific publication by [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) 
- Several functions contained in `Dependencies` are tailored to data stored with the directory structure and nomenclature used by Guidali et al. (check OSF). Should you reuse the code on different data stored with different criteria, those steps are likely to become suboptimal or useless 

---

# **Dependencies:**

| Language/Package | Version tested on | 
|------------------|-------------------|
|[Matlab](https://www.mathworks.com/products/matlab.html) | R2022a | 
|[Curve Fitting Toolbox](https://www.mathworks.com/help/curvefit/?s_tid=srchbrcm) | R2022a | 




