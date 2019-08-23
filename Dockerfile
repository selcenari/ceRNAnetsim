FROM alperyilmaz/cerna-binder

COPY --chown=rstudio:rstudio ./vignettes/* ${HOME}/
