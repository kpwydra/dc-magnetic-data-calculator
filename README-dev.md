# Diamagnetic Calculations Explained

#### This document serves as an introduction to diamagnetic contribution calculations. The section is divided into several chapters. The first chapter briefly explains the concept of diamagnetic susceptibility. The subsequent chapters discuss several examples of chemical compounds for which the diamagnetic contribution has been calculated. To illustrate these computations, we will start with the simplest example and gradually increase the level of difficulty in the following chapters.

The procedure presented herein for calculating the diamagnetic contribution is based on the article (1).

## CONTENTS
> ###   1. Introduction to Diamagnetic Susceptibility.
> ###   2. Diamagnetic Contribution Calculations
> ####  2.1 2-methylpropan-2-ol.
> ###   3. Literature.

$$
\chi_D = \sum_i \chi_{Di} + \sum_i \lambda_i \quad \text{(1)}
$$

### 2.1 2-methylpropan-2-ol
Our first example of a compound for which we will determine the diamagnetic contribution is 2-methylpropan-2-ol, an alcohol. To calculate the diamagnetic contribution, we use Eq. (1). 

<img src="https://github.com/user-attachments/assets/9783a0bc-fcfb-4c53-abe4-fe5b18ec0690" width="500" alt="Comound1">

> **Figure 1** Structure of 2-methylpropan-2-ol.

Figure 1 shows that 2-methylpropan-2-ol is a neutral molecule in which all atoms are covalently bonded into a branched chain structure. Therefore, expansion of the first sum in the equation is:

$$
\sum_i \chi_{Di} = 4 \chi_{C} + 10 \chi_{H} + \chi_{O}
$$

Taking data from Table 1 from the reference (1), we have:

$$
\sum_i \chi_{Di} = [4 \times (-6.00) + 10 \times (-2.93) + (-4.6)] \times 10^{-6} \ cm^3 \ mol^{-1} = -28.6 \times 10^{-6} \ cm^3 \ mol^{-1}
$$

Accordingly to Table 2 in the article (1), C–H and C–C single bonds are set to have a value of $\lambda_i$ equal 0.0 $cm^3 \, mol^{-1}$. Since there is no information regarding O–H and C–O bonds, they were also assumed to have $\lambda_i$ equal to 0.0 $cm^3 \, mol^{-1}$ as well. As a result, the sum $\sum_i \lambda_i = 0$ and $\chi_D = \sum_i \chi_{Di} = -28.6 \times 10^{-6} \ cm^3 \ mol^{-1}$.


## Literature
> (1) G. A. Bain, J. F. Berry, J. Chem. Educ., 2008, 85, 532-536. DOI: 10.1021/ed085p532
