# Autolaskuri

_Autolaskuri_ is a Finnish word for car counter. It is a training project to 
familiarize myself with Elm language.

Idea is to count oncoming different vehicles: sedans, trucks, motorcycles, etc... 

* counter cannot get negative
* editing counters (add, remove, change name)

## Backend

I've followed [Elm tutorial](https://www.elm-tutorial.org/) instructions to create 
backend server.

Create fake API with [json-server](https://github.com/typicode/json-server)
```
yarn init
yarn add json-server@0.14.0
```

```api.js``` defines the server and ```db.json``` fakes the database.

And then run it
```
node api.js
```

## Webpack

With [Webpack](https://webpack.js.org/) we can get more support for JavaScript 
and CSS handling. ```webpack.config.js``` and ```package.js``` defines the running 
environment and finally I have used **Node Foreman** to run both backend and 
frontend servers. Foreman is configured in ```Procfile```.

Then running Autolaskuri is done by
```
yarn start
```

Application then runs in ```http://localhost:3000``` 
and backend returns vehicles to count at ```http://localhost:4000/counters```

