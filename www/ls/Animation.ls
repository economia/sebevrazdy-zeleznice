window.Animation = class Animation
    step: 0.3_per_second
    currentValue: 0
    stopping: no
    t0 : null
    ->
        @event = d3.dispatch "frame"
        @on = @event~on

    start: ->
        window.requestAnimationFrame @~increment

    increment: (t) ->
        if @t0 isnt null
            @currentValue += (t - @t0) * @step / 1000
            if @currentValue > 3 and @step < 20
                @step *= 1.004
            @event.frame @currentValue
        @t0 = t

        if not @stopping
            window.requestAnimationFrame @~increment
