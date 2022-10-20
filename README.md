# LinguaFinder
[![Maintainability](https://api.codeclimate.com/v1/badges/b4231ad17ab153f75484/maintainability)](https://codeclimate.com/github/PabloScolpino/lingua-finder/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b4231ad17ab153f75484/test_coverage)](https://codeclimate.com/github/PabloScolpino/lingua-finder/test_coverage)

This is a custom web scraper, that piggybacks on google custom search engine to find pages of interest. The pages found are downloaded, and parsed looking for custom (and complex) search criterias.


# Running interactive cypress tests

    brew install xquartz
    export IP=$(ipconfig getifaddr en0)
    export CYPRESS_DISPLAY=$IP:0
    xhost +
    docker-compose run cypress

# Please check out the live system:

[production](https://lingua-finder.ar.olumpos.net)
