FROM selcenari/cernanetsim_binder

COPY --chown=rstudio:rstudio ./vignettes/. ${HOME}/
RUN echo '.First <- function(){\n cat("\\n\n  Welcome at ceRNAnetsim package!\n  You can look at the ordered vignette files in working directory.\n  Lets begin with basic usage! \\n\\n")\n}' > ${HOME}/.Rprofile && chown rstudio:rstudio ${HOME}/.Rprofile

RUN mv basic_usage.Rmd 01_basic_usage.Rmd && mv auxiliary_commands.Rmd 04_auxiliary_commands.Rmd && \
    mv convenient_iteration.Rmd 02_convenient_iteration.Rmd && mv mirtarbase_example.Rmd 03_mirtarbase_example.Rmd
