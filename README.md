# Carbon

#### TODOs

- [ ] send API requests using Tesla
- [ ] set up DB + Ecto
- [ ] decide on a reasonable testing strategy
- [ ] draw high level programm overview 

### How good is the air?

#### Intro
With development of enhanced monitoring systems everywhere, we're now able to get lots of information about things around us. Lots of facilities offer API to access and leverage data.  For this test exercise we will use one of those APIs and play with it's data.

#### Usage of The API
The API we are going to use will be the one from UK National Grid, which reports CO2 emissions related to electricity production – https://carbon-intensity.github.io/api-definitions/#carbon-intensity-api-v2-0-0. Our goal is to store actual intensity values they provide with as much of time-wise granularity as possible so we can leverage this data later (to build models, to plot graphs, etc.). Just one value with a time point along.

#### Implementation details
The implementation should resemble "real software ready for production". Which means it's written in a conscious way and well tested. It should refill missing data in case of own downtime or Internet connection going down.

