local stages = {
    [1] = {
        noon = {
            reaction_window = 1.0,
            time_till_noon_min = 4.0,
            time_till_noon_max = 10.0,
        },
        enemy = {
            folder_path = "assets/enemy1 shootout",
            x = 190,
            y = 90,
        },
        player = {
            x = 20,
            y = 101,
        },
        bullet = {
            x = 0,
            y = 0,
        },
        sprites = {
            sun = "assets/sun.png",
            foreground = "assets/foreground.png",
            background = "assets/background.png",
        },
        distraction_interval = 2.0,
        distractions = {
            {
                folder_path = "assets/distractions/stage 1/cowboy frames",
                frame_duration = 0.1,
                x = 0,
                y = 0,
            },
            {
                folder_path = "assets/distractions/stage 1/tumbleweed frames",
                frame_duration = 0.1,
                x = 0,
                y = 0,
            },
        },
    },
}

return stages
