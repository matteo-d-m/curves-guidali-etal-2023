## **Psychometric curves fitting** ##

This repository contains my personal copy of MATLAB code that I wrote for [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) and that has already been published on the Open Science Framework (OSF) at [this HTTPS URL](https://osf.io/6mypr/) (`Task and script/PSE script`). 

Broadly speaking, this code preprocesses behavioural data from a computerized landmark task (LM), fits psychometric curves to them, and plots them. Please refer to either [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) or the associated OSF project page for details. 

---

The code is organized as follows:
- `Dependencies` is a folder containing MATLAB code files (`.m`) with functions to:
    - Preprocess LM data
    - Compute LM's dependent variables 
    - Fit psychometric curves
    - Draw and display psychometric curves
- `fit_psyfunc_ccpas_master.m` calls the functions contained by `Dependencies`, in the right order

Running `fit_psyfunc_ccpas_master.m` is enough to reproduce the results described by [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216). Raw data can be found on the [OSF](https://osf.io/6mypr/). 

Please preserve the current directory structure to minimize the risk of code breaking. 

**Note that:** 
- The code in this repository is just my personal copy of the one published on the OSF. The official archive of supplementary materials (including code) for [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) is the one on the OSF
- The code in this repository can be reused under the terms described by the original license (CC-BY-4.0), which you can read on the OSF. Should you reuse this code in published work, please cite the scientific publication by [Guidali et al. (2023)](https://www.sciencedirect.com/science/article/pii/S0010945223002216) 
- Several functions contained in `Dependencies` are tailored to data stored with the directory structure and nomenclature used by Guidali et al. (check OSF). Should you reuse the code on different data stored with different criteria, those steps are likely to become suboptimal or useless 

---

# **Dependencies:**

| Language/Package | Version tested on | 
|------------------|-------------------|
|[MATLAB](https://www.mathworks.com/products/MATLAB.html) | R2022a | 
|[Curve Fitting Toolbox](https://www.mathworks.com/help/curvefit/?s_tid=srchbrcm) | R2022a | 




