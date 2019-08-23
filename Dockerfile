FROM alperyilmaz/cerna-binder

COPY --chown=rstudio:rstudio ./vignettes/. ${HOME}/

RUN rm ${HOME}/*.png ${HOME}/*samp && mv basic_usage.Rmd 01_basic_usage.Rmd && mv small_sample.Rmd 02_small_sample.Rmd && \
     mv convenient_iteration.Rmd 03_convenient_iteration.Rmd && mv perturbation_sample.Rmd 04_perturbation_sample.Rmd && \
     mv mirtarbase_example.Rmd 05_mirtarbase_example.Rmd && mv auxiliary_commands.Rmd 06_auxiliary_commands.Rmd
