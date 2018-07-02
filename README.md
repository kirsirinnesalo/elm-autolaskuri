# Autolaskuri

*Autolaskuri* is a Finnish word for car counter. It is a training project to 
familiarize myself with Elm language.

Idea is to count oncoming different vehicles: sedans, trucks, motorcycles, etc... 

- [x] counter cannot get negative
- [x] editing counters (add, remove, change name)
  - [x] enter saves edit
  - [ ] esc reverts edit
- [x] save state
- [ ] rearranging counters, drag and drop; see [elm-draggable](http://package.elm-lang.org/packages/zaboco/elm-draggable/latest)
- [ ] login and user-specific counters

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

### db.json
```
{
  "counters" : [
    { "id": 1, "name": "Henkilöauto", "count": 0 },
    { "id": 2, "name": "Kuorma-auto", "count": 0 },
    { "id": 3, "name": "Linja-auto", "count": 0 }
  ]
}
```

## Webpack

[Elm Platform](http://elm-lang.org/install) contains interactive development tool 
**Elm Reactor** which is easy to use webapp server for running Elm apps. 
Just run ```elm-reactor``` and navigate to ```http://localhost:8000``` and look for *MainApp.elm*.

With [Webpack](https://webpack.js.org/) we can get more support for JavaScript 
and CSS handling. ```webpack.config.js``` and ```package.js``` defines the running 
environment and finally I have used [Node Foreman](https://github.com/strongloop/node-foreman) to run both backend and 
frontend servers. Foreman is configured in ```Procfile```.

Then running *Autolaskuri* is done by
```
yarn start
```

Application then runs in ```http://localhost:3000``` 
and backend returns vehicles to count at ```http://localhost:4000/counters```

