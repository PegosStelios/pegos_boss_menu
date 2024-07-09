RegisterNetEvent('pegos_boss_menu:client:promoteMenu', function(args)
    args = lib.callback.await('pegos_boss_menu:server:getGrades')

    local options = {}
    for i = 1, #args do
        table.insert(options, {
            title = args[i]['label'],
            onSelect = function()
                local input = lib.inputDialog('Enter ID you wish to promote', {
                    {type = 'number', label = 'ID', description = '', icon = 'hashtag', required = true},
                })

                TriggerServerEvent('pegos_boss_menu:server:promote', {
                    ['grade'] = args[i]['grade'],
                    ['job'] = args[i]['job'],
                    ['target'] = input[1]
                })
            end,
        })
    end

    lib.registerContext({
      id = 'event_promote_menu',
      title = 'Select Rank',
      description = 'The member will aquire the selected rank',
      menu = 'boss_menu',
      options = options
    })

    lib.showContext('event_promote_menu')
end)

lib.registerContext({
    id = 'boss_menu',
    title = 'Boss Menu',
    options = {
    {
        title = 'Promote',
        description = 'Promote a member',
        icon = 'fa-solid fa-circle-up',
        event = 'pegos_boss_menu:client:promoteMenu',
        arrow = true,
        args = {
          grades = nil
        }
      },
      {
        title = 'Recruit',
        description = 'Recruit a member',
        icon = 'fa-solid fa-users',
        onSelect = function()
            local input = lib.inputDialog('Recruit', {
                {type = 'number', label = 'ID', description = 'Player ID', icon = 'hashtag', required = true},
            })

            if not input then return end

            TriggerServerEvent('pegos_boss_menu:server:recruit', {
                ['target'] = input[1]
            })
        end,
      },
      {
        title = 'Dismiss',
        description = 'Send a member packing',
        icon = 'trash',
        onSelect = function()
            local input = lib.inputDialog('Dismiss', {
                {type = 'number', label = 'ID', description = 'Player ID', icon = 'hashtag', required = true},
            })

            if not input then return end

            TriggerServerEvent('pegos_boss_menu:server:dismiss', {
                ['target'] = input[1]
            })
        end,
      },
    }
})

for _, location in ipairs(Config.Locations) do
    exports.ox_target:addSphereZone({
        name = location.name .. "_boss_menu",
        coords = location.coords,
        debug = Config.Debug,
        radius = 1,
        options = {
            {
                icon = 'fa-solid fa-user',
                groups = {
                    [location.name] = Config.BossGrade
                },
                label = 'Boss Menu',
                onSelect = function()
                    lib.showContext('boss_menu')
                end,
            }
        }
    })

end
