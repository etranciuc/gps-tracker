define ->
  'use strict'

  # The routes for the application. This module returns a function.
  # `match` is match method of the Router
  (match) ->
    match '', 'home#index', name: 'home'
    match 'test', 'home#index', name: 'home'