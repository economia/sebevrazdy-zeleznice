window.Animation = class Animation
    step: 1_per_second
    currentValue: 0
    stopping: no
    ->
        @event = d3.dispatch "frame"
        @on = @event~on

    start: ->
        window.requestAnimationFrame @~increment

    increment: (t) ->
        @currentValue = t * @step / 1000
        @event.frame @currentValue
        if not @stopping
            window.requestAnimationFrame @~increment
