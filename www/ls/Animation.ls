window.Animation = class Animation
    step: 0.3_per_second
    currentValue: 0
    stopped: yes
    t0 : null
    ->
        @event = d3.dispatch "frame"
        @on = @event~on

    start: ->
        window.requestAnimationFrame @~increment if @stopped
        @stopped = no

    stop: ->
        @stopped = yes

    restart: ->
        @currentValue = 0
        @step = 0.3
        @t0 = null
        @start!

    increment: (t) ->
        if @t0 isnt null
            @currentValue += (t - @t0) * @step / 1000
            if 800 > @currentValue > 3 and @step < 20
                @step *= 1.004
            else if @currentValue > 850 and @step > 1
                @step *= 0.98
            @event.frame @currentValue
        @t0 = t

        window.requestAnimationFrame @~increment if not @stopped
