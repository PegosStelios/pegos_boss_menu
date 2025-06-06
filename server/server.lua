lib.callback.register('pegos_boss_menu:server:getGrades', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)
    local jobs = ESX.GetJobs()
    local availableJobs = {}
    local playerJob = xPlayer.getJob()
    local options = {}

    for k, v in pairs(jobs) do
        if k == playerJob.name then
            availableJobs[k] = {name = v.name, grades = {}}
            for gradeKey, gradeValue in pairs(v.grades) do
                table.insert(availableJobs[k].grades, {grade = gradeValue.grade, label = gradeValue.label})
            end
        end
    end
    for jobName, jobData in pairs(availableJobs) do
        for _, grade in ipairs(jobData.grades) do
            table.insert(options, {
                name = jobName,
                grade = grade.grade,
                label = grade.label
            })
        end
    end

   return options
end)

lib.callback.register('pegos_boss_menu:server:getMarkers', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)
    local playerJob = xPlayer.getJob()

    if playerJob.grade == 0 then return true end
end)

RegisterNetEvent('pegos_boss_menu:server:promote', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isClose = false
    local threshold = 20
    local job = xPlayer.getJob()
    local xPlayerTarget = ESX.GetPlayerFromId(data.target)
    print('Target:' .. data.target)

    local targetJob = xPlayerTarget.getJob()
    if data == nil then
        print('ban')
        return
    end

    if job.name ~= Config.BossGradeName then
        print('ban')
        return
    end

    for _, location in ipairs(Config.Locations) do
        local distance = ESX.CalculateDistance(xPlayer.getCoords(true), location.coords)

        if distance < threshold then
            isClose = true
            break
        end
    end

    if not isClose then
        print('ban')
        return
    end

    if job.name == targetJob.name then
        xPlayerTarget.setJob(job.name, data.grade)
    else
        print('abuse')
        return
    end
end)


RegisterNetEvent('pegos_boss_menu:server:recruit', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isClose = false
    local threshold = 20
    local job = xPlayer.getJob()
    local xPlayerTarget = ESX.GetPlayerFromId(data.target)

    if data == nil or data.target == nil then
        print('ban - data')
        return
    end

    if job.name ~= Config.BossGradeName then
        print('ban - grade')
        return
    end

    for _, location in ipairs(Config.Locations) do
        local distance = ESX.CalculateDistance(xPlayer.getCoords(true), location.coords)

        if distance < threshold then
            isClose = true
            break
        end
    end

    if not isClose then
        print('ban - distance')
        return
    end

    xPlayerTarget.setJob(job.name, 1)
end)

RegisterNetEvent('pegos_boss_menu:server:dismiss', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isClose = false
    local threshold = 20
    local job = xPlayer.getJob()
    local xPlayerTarget = ESX.GetPlayerFromId(data.target)

    if data == nil or data.target == nil then
        print('ban - idk')
        return
    end

    if job.name ~= Config.BossGradeName then
        print('ban - grade')
        return
    end

    for _, location in ipairs(Config.Locations) do
        local distance = ESX.CalculateDistance(xPlayer.getCoords(true), location.coords)

        if distance < threshold then
            isClose = true
            break
        end
    end

    if not isClose then
        print('ban - distance')
        return
    end

    xPlayerTarget.setJob(Config.UnemployedJobName, Config.UnemployedGrade)
end)
