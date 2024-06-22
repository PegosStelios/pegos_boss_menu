RegisterNetEvent('pegos_boss_menu:server:promoteMenu', function(args)
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
      id = 'event_menu',
      title = 'Select Rank',
      description = 'The member will aquire the selected rank',
      menu = 'boss_menu',
      options = options
    })

    lib.showContext('event_menu')
end)

lib.registerContext({
    id = 'boss_menu',
    title = 'Boss Menu',
    options = {
    {
        title = 'Promote',
        description = 'Promote a member',
        icon = 'check',
        event = 'pegos_boss_menu:server:promoteMenu',
        arrow = true,
        args = {
          grades = nil
        }
      },
      {
        title = 'Recruit',
        description = 'Recruit a member',
        icon = 'plus',
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

local uiText = "Press [E] to open boss menu"

function createPointAndMarker(location)
    local point = lib.points.new({
        coords = location.coords,
        distance = location.distance,
    })

    local marker = lib.marker.new({
        coords = location.coords,
        type = location.type,
    })

    function point:nearby()
        marker:draw()

        if self.currentDistance < 1.5 then
            if not lib.isTextUIOpen() then
                lib.showTextUI(uiText)
            end

            if IsControlJustPressed(0, 51) then
                lib.showContext('boss_menu')
            end
        else
            local isOpen, currentText = lib.isTextUIOpen()
            if isOpen and currentText == uiText then
                lib.hideTextUI()
            end
        end
    end
end

for _, location in ipairs(Config.Locations) do

    local markers = lib.callback.await('pegos_boss_menu:server:getMarkers')

    if markers then
        createPointAndMarker(location)
    end
end