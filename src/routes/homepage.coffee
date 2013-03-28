module.exports = (app) ->

  app.get "/", (req, res) ->
    res.render "homepage",
      title: "Express"

