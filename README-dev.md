# Diamagnetic Calculations Explained

## 1 Document Goals <a id="document-goals"></a>
 - This document serves as an introduction to diamagnetic contribution calculations
 - Here, we explain **step-by-step**, the theoretical foundations of this problem. Using few simple examples, we show how we do our calculations.

<!-- ## Document Structure -->
<!-- Not sure if this section is really necessary. From my perspective it introduces noise. We still can have this information, in each section instead. I would rather keep the header simple and stick to Document Goals -->
 <!-- - The section is divided into several chapters. The first chapter briefly explains the concept of diamagnetic susceptibility. The subsequent chapters discuss several examples of chemical compounds for which the diamagnetic contribution has been calculated. To illustrate these computations, we will start with the simplest example and gradually increase the level of difficulty in the following chapters. -->

## Table of Contents
1. [Document Goals](#document-goals)
2. [Formulas](#formulas)
3. [Examples](#examples)
    1. [Example I](#example-i)
    1. [Example II](#example-ii)
    1. [Example III](#example-iii)
4. [Literature references](#literature-references)


## 2 Formulas <a id="formulas"></a>

### Formula (2) <a id="formula-2"></a>
$$
\chi_D = \sum_i \chi_{Di} + \sum_i \lambda_i \quad
$$


## 3 Examples <a id="examples"></a>
### 3.1 **Example I** - `2-methylpropan-2-ol` <a id="example-i"></a>
> Our first example of a compound for which we will determine the diamagnetic contribution is `2-methylpropan-2-ol`, an alcohol. To calculate the diamagnetic contribution, we use [Eq. (2)](#formula-2). 

&nbsp;
<p align="center">
  <img src="https://github.com/user-attachments/assets/9783a0bc-fcfb-4c53-abe4-fe5b18ec0690" width="500" alt="Comound1">
</p>
<p align="center">
  <b>Figure 1</b> Structure of 2-methylpropan-2-ol.
</p>
&nbsp;

Figure 1 shows that 2-methylpropan-2-ol is a neutral molecule in which all atoms are covalently bonded into a branched chain structure. Therefore, expansion of the first sum in the equation is:

$$
\sum_i \chi_{Di} = 4 \chi_{C} + 10 \chi_{H} + \chi_{O}
$$

Taking data from Table 1 from the reference $^{(1)}$, we have:

$$
\sum_i \chi_{Di} = [4 \times (-6.00) + 10 \times (-2.93) + (-4.6)] \times 10^{-6} \ cm^3 \ mol^{-1} = -57.9 \times 10^{-6} \ cm^3 \ mol^{-1}
$$

Accordingly to Table 2 in the article $^{(1)}$, C–H and C–C single bonds are set to have a value of $\lambda_i$ equal 0.0 $cm^3 \, mol^{-1}$. Since there is no information regarding O–H and C–O bonds, they were also assumed to have $\lambda_i$ equal to 0.0 $cm^3 \, mol^{-1}$. As a result, the sum $\sum_i \lambda_i = 0$ and $\chi_D = \sum_i \chi_{Di} = -57.9 \times 10^{-6} \ cm^3 \ mol^{-1}$.


&nbsp;
### 3.2 **Example II** - `Chlorobenzene` <a id="example-ii"></a>
> The structure of chlorobenzene consists of a six-membered, benzene ring with alternating single C-C and double C=C bonds (Figure 2). Five carbon atoms are additionally bound to one hydrogen atom, while the last one is connected to a chlorine atom.

&nbsp;
<p align="center">
  <img src="https://github.com/user-attachments/assets/961a1fb6-eedc-483f-a02e-e91c4735dbd0" alt="comound2" width="500">
</p>

<p align="center">
  <b>Figure 2</b> Structure of chlorobenzene.
</p>
&nbsp;

To calculate $\sum_i \chi_{Di}$ sum from Eq. (2), we need to consider Pascal's constant for carbon atoms within the ring fragment of the molecule, which is $\chi_{C(ring)} = -6.24 \times 10^{-6} \ cm^3 \ mol^{-1}$ (value taken from Table 1 in $^{(1)}$). The sum is equal to:

$$
\sum_i \chi_{Di} = 6 \chi_{D(C(ring))} + 5 \chi_{D(H)} + \chi_{D(Cl)} = [6 \times (-6.24) + 5 \times (-2.93) + (-20.1)] \times 10^{-6} \ cm^3 \ mol^{-1} = -72.19 \times 10^{-6} \ cm^3 \ mol^{-1}
$$

For chlorobenzene, the sum $\sum_i \lambda_i$ in Eq. (2) is not equal to zero. There are two Pascal's constants that we have to consider: $\lambda_{benzene}$ and $\lambda_{Ar-Cl}$. The first takes into account the presence of the benzene ring within the structure. The second Pascal's constant considers the Ar-Cl bond. Here, "Ar" corresponds to any aromatic fragment (in this particular case benzene fragment). It means that Ar-Cl is a specific case of the C-Cl bond, where the carbon atom corresponds to the aromatic fragment. The resulting sum is:

$$
\sum_i \lambda_i = \lambda_{benzene} + \lambda_{Ar-Cl} = [(–1.4) + (–2.5)] \times 10^{-6} \ cm^3 \ mol^{-1} = -3.9 \times 10^{-6} \ cm^3 \ mol^{-1}
$$

Finally, the diamagnetic contribution for the compound is:

$$
\chi_D = \sum_i \chi_{Di} + \sum_i \lambda_i  = [(-72.19) + (-3.9)] \times 10^{-6} \ cm^3 \ mol^{-1} = -76.09 \times 10^{-6} \ cm^3 \ mol^{-1}
$$

### 3.3 **Example III** - `Chalconatronite` <a id="example-iii"></a>
> Chalconatronite is a carbonate mineral with the chemical formula Na<sub>2</sub>Cu(CO<sub>3</sub>)<sub>2</sub>•3H<sub>2</sub>O. This is an ionic compound, which means that some of the atoms are not covalently bonded. Have a look at the structural formula of the mineral:

&nbsp;
<p align="center">
  <img src="https://github.com/user-attachments/assets/217259a8-a64f-4132-9d08-12af35ba8eea" alt="mineral" width="300">
</p>

<p align="center">
  <b>Figure 3</b> Structural formula of chalconatronite.
</p>
&nbsp;

The mineral is composed of two types of cations (species with a positive charge), Cu<sup>2+</sup> and Na<sup>+</sup>, and one type of anion, the carbonate CO<sub>3</sub><sup>2−</sup>. Due to their opposite charges, cations and anions attract each other and are organized into a three-dimensional crystal lattice. Within this lattice, there are additional water molecules. To calculate the $\chi_D$ for chalconatronite, we have to account for the diamagnetic contribution of all species present in the chemical formula of the compound:

$$
\chi_D = 2\chi_{D(Na^+)} + \chi_{D(Cu^{2+})} + 2\chi_{D(CO_3^{2-})} + 3\chi_{D(H_2O)}
$$

Since Na<sup>+</sup> and Cu<sup>2+</sup> are ions, we should use Pascal's constants from Table 6 in $^{(1)}$. Those are $\chi_{D(Na^+)} = -6.8 \times 10^{-6} \ cm^3 \ mol^{-1}$ and $\chi_{D(Cu^{2+})} = -11 \times 10^{-6} \ cm^3 \ mol^{-1}$, respecetively. We preceed to the carbonate anion, which is a polyatomic charged species. Fortunately, Pascal's constants for common anions were catalogued in Table 3 in $^{(1)}$. The respective constant equals $\chi_{D(CO_3^{2-})} = -28.0 \times 10^{-6} \ cm^3 \ mol^{-1}$. Our last species is water. The H<sub>2</sub>O molecule is a common ligand (species that can bind to a metal ion), and its Pascal constant, which is listed in Table 4 in $^{(1)}$, is equal to $\chi_{D(H_2O)} = -13 \times 10^{-6} \ cm^3 \ mol^{-1}$. Finally, we have all data to calculate diamagnetic contribution for the mineral:

$$
\chi_D = [2 \times (-6.8) + (-11) + 2 \times (-28.0) + 3 \times (-13)] \times 10^{-6} \ cm^3 \ mol^{-1} = -119.6 \times 10^{-6} \ cm^3 \ mol^{-1}
$$


### 3.3 **Example IIV** - `Coordination compound`
> The coordination compound under consideration has the chemical formula of [Fe<sup>III</sup>(bipy)(phen)(py)(CH<sub>3</sub>OH)]\(PhAs<sup>V</sup>O<sub>3</sub>\)(ClO<sub>4</sub>) and its structural formula is presentend in Figure 4. The compound is composed of complex cation in which the central Fe<sup>3+</sup> binds four different organic molecules (ligands). These molecules are: methanol (CH<sub>3</sub>OH), pyridine (py), 1,10-phenanthroline (phen) and 2,2'-bipirydine (bipy). Since these molecules are neutral, the overall charge of the complex cation is the same as in Fe<sup>3+</sup>. To compensate this positive charge (+3), there are two different anions, phenylarsenate(V) (PhAs<sup>V</sup>O<sub>3</sub><sup>2-</sup>) and perchlorate (ClO<sub>4</sub><sup>-</sup>), having charge of -2 and -1, respectively.

&nbsp;
<p align="center">
 <img src="https://github.com/user-attachments/assets/19212caf-b4bf-415b-a46b-a71eb135c473" alt="most complicated molecule" width="500">
</p>

<p align="center">
  <b>Figure 3</b> Structural formula of complex [Fe<sup>III</sup>(bipy)(phen)(py)(CH<sub>3</sub>OH)](PhAs<sup>V</sup>O<sub>3</sub>)(ClO<sub>4</sub>).
</p>

The overall diamagnetic susceptibility of our coordination compound is equal to the sum of the diamagnetic contributions from the complex cation [Fe<sup>III</sup>(bipy)(phen)(py)(CH<sub>3</sub>OH)]<sup>3+</sup> and the two anions PhAs<sup>V</sup>O<sub>3</sub><sup>2-</sup> and ClO<sub>4</sub><sup>-</sup>, as follows:

$$
\chi_D = \chi_{D\([ \mathrm{Fe^{III}(bipy)(phen)(py)(CH_3OH)]^{3+}} \)} + \chi_{D(\mathrm{PhAs^{V}O_3^{2-}}\)} + \chi_{D(\mathrm{ClO_4^{-}}\)}
$$

Although the structure of the complex cation looks scary, calculating the diamagnetic contribution for this species is fairly straightforward. This is because Table 4 in $^{(1)}$ provides Pascal's constants for all the ligands present in the complex cation [Fe<sup>III</sup>(bipy)(phen)(py)(CH<sub>3</sub>OH)]<sup>3+</sup>. The only remaining value is the Pascal's constant for the Fe<sup>3+</sup> cation, which we take from Table 6 in the reference.

$$
\chi_{D\([ \mathrm{Fe^{III}(bipy)(phen)(py)(CH_3OH)]^{3+}} \)} = \chi_{D\(Fe^{3+})} + \chi_{D\(bipy)} + \chi_{D\(phen)} + \chi_{D\(py)} + \chi_{D\(CH_3OH)}
$$

$$
\chi_{D\([ \mathrm{Fe^{III}(bipy)(phen)(py)(CH_3OH)]^{3+}} \)} =
$$

We now proceed to the two anions of our coordination compound. In the case of perchlorate anion, the diamagnetic contribution is given in Table 3 in $^{(1)}$ and is equal to $\chi_{D(ClO_4^{-})} = -32.0 \times 10^{-6} \ cm^3 \ mol^{-1}$. For the second anion, phenylarsenate(V) (PhAs<sup>V</sup>O<sub>3</sub><sup>2-</sup>), the situation is more complicated as magnetic contribution for this species is not listed in Tables 3 and 4 in the reference, so we need to calculate it stepwise. The calculations are similar as for Example II (see chapter 3.2):

$$
\chi_{\mathrm{PhAs^{V}O_3^{2-}}\} = \sum_i \chi_{Di} + \sum_i \lambda_i \quad
$$

We calculate first sum using Pascal's constants of all elements present, remembering to choose appropriate value (Table 1 in $^{(1)}$). Note that all carbon atoms form ring, while arsenic atom exhibits oxidation state of V. It should also be noted that our procedure does not account for the overall negative charge of the anion, leading to an overestimation of the final value.

$$
\sum_i \chi_{Di} = 6 \chi_{D(C(ring))} + 5 \chi_{D(H)} + \chi_{D(As^{V})} + 3 \chi_{D(O)}
$$

$$
\sum_i \chi_{Di} =
$$

## 4 Literature references <a id="literature-references"></a>
> The procedure presented in this document is based on the following articles:
 - [(1)](http://linktodocument.com) G. A. Bain, J. F. Berry, J. Chem. Educ., 2008, 85, 532-536. DOI: 10.1021/ed085p532
