# update services branch with master
git checkout services
git merge --no-ff master
git push -u origin services
git checkout master

# calculate code coverage
Rscript -e 'covr::codecov()'

# deploy package vignettes/articles to gh-pages
Rscript -e 'devtools::install(); pkgdown::deploy_site_github()'
