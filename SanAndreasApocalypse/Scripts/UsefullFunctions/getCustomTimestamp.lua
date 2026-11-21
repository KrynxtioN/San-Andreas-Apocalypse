function getCustomTimestamp(year, month, day, hour, minute, second)
    local dateTable = {
        year = year,
        month = month,
        day = day,
        hour = hour or 0,
        min = minute or 0,
        sec = second or 0
    }

    return os.time(dateTable)
end