local dfpwm = require("cc.audio.dfpwm")

local driverType = "dfpwm"

local Track = {}

local function adjustVolume(buffer, volume)
    for i = 1, #buffer do
        buffer[i] = buffer[i] * volume
    end
end

local function playAudio(speakers, sample)
    adjustVolume(sample, speakers.volume)
    if speakers.isMono then
        return speakers.left.playAudio(sample, speakers.distance)
    end

    return speakers.left.playAudio(sample, speakers.distance) and speakers.right.playAudio(sample, speakers.distance)
end

local function stopAudio(speakers)
    speakers.left.stop()
    if speakers.isMono then
        return
    end
    speakers.right.stop()
end

function Track:run()
    while not self.disposed do
        while self.state == "paused" do
            os.pullEvent("quartz_play")
        end
        local chunk = self.data:sub((self.position + 1), self.position + self.blockSize)
        if not chunk or chunk == "" then
            os.pullEvent("speaker_audio_empty")
            sleep(0.5)
            os.queueEvent("quartz_driver_end")
            break
        end

        local sample = self.decoder(chunk)
        while self.state ~= "paused" and not self.disposed and not playAudio(self.speakers, sample) do
            os.pullEvent("speaker_audio_empty")
            sleep(0.5)
        end
        self.position = self.position + self.blockSize
    end
end

function Track:getMeta()
    return {
        artist = "Unknown artist",
        title = "Unknown title",
        album = "Unknown album",
        size = self.size,
        length = self.size / 6000,
    }
end

function Track:getState()
    return self.state
end

function Track:getPosition()
    return self.position / 6000
end

function Track:setPosition(pos)
    if pos < 0 then
        pos = 0
    end
    self.position = pos * 6000
end

function Track:play()
    self.state = "running"
    os.queueEvent("speaker_audio_empty")
    os.queueEvent("quartz_play")
end

function Track:pause()
    self.state = "paused"
    os.queueEvent("quartz_pause")
    stopAudio(self.speakers)
end

function Track:stop()
    self.state = "paused"
    self.position = 0
    os.queueEvent("quartz_pause")
    stopAudio(self.speakers)
end

function Track:dispose()
    self.disposed = true
end

local function new(drive, speakers)
    local drivePath = drive.getMountPath()
    local found = fs.find(fs.combine(drivePath, "*.dfpwm"))
    local filePath = found[1]
    if not filePath then
        error("No compatible files!")
    end

    local handle = fs.open(filePath, "rb")
    local data = handle.readAll()
    handle.close()
    local size = #data

    local track = {
        state = "paused",
        data = data,
        blockSize = 6000,
        position = 0,
        type = driverType,
        decoder = dfpwm.make_decoder(),
        filePath = filePath,
        speakers = speakers,
        size = size,
        disposed = false,
    }

    setmetatable(track, { __index = Track })
    return track
end

local function checkCompatibility(drive)
    if not drive.hasData() then
        return false
    end

    local path = drive.getMountPath()
    local found = fs.find(fs.combine(path, "*.dfpwm"))
    return #found > 0, 10
end

return {
    new = new,
    type = driverType,
    checkCompatibility = checkCompatibility,
}
