![GitHub](https://img.shields.io/github/license/dominikvogel/r-teaching-script.svg) ![](https://img.shields.io/github/release/DominikVogel/session2CO.svg)

# ``session2CO``
R package to converts the output of sessionInfo() to lines of RUN Rscript code for Code Ocean

# Install
Before installing the package, you need to install the [``n2kanalysis``](https://github.com/inbo/n2kanalysis) package from Github

```r
# install devtools if not yet installed
# install.packages("devtools")
devtools::install_github("inbo/n2kanalysis")
```

Afterward, you can install ```session2CO``` from GitHub:

```r
devtools::install_github("DominikVogel/session2CO")
```

# Usage
[Code Ocean](https://codeocean.com/) allows users to specify the R packages (and their version) to be included in a Docker Image. There is also a very handy frontend where users can specify their packages. However, if you want to include a lot of packages this might be difficult.

``session2CO()`` therefore uses the information about the uses packages provided by ``R`` via the ``sessionInfo()`` function and creates the code that can be added to the Dockerfile.

## Step by Step
1. Create your CodeOcean Capsule
2. Install ``session2CO``
3. Run all your scripts, so all necessary packages are loaded
4. Store the sessionInfo in a new object: e.g. ``sess <- sessionInfo()``
5. Run session2CO: ```session2CO::session2CO(sess = sess, path = "sessioninfos.txt")```
6. Copy and paste the content of the created txt file to your Dockerfile
7. Run your CodeOcean Capsule
