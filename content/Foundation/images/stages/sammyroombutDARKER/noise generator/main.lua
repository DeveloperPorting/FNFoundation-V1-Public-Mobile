-- vivi's noise texture was like 40 mb and i thought i could do better so i did -xeight
-- included for the fun of it
-- outputs the files into your save directory, google where it is for love2d
local canvas
local values = {}

local w = 400
local h = 200
local toGen = 1

local generated = 0

function love.load()

    canvas = love.graphics.newCanvas(w, h)
    randGen = love.math.newRandomGenerator()
    randGen:setSeed(os.time())

    for i = 0, 3, 1 do
        generate()
        generated = generated + 1
    end

    love.window:close()
end

function generate()
    for i = 0, w, 1 do
        values[i] = {}
        for j = 0, h, 1 do
            values[i][j] = randGen:random(0, 1)
        end
    end

    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)

    for i = 0, w, 1 do
        for j = 0, h, 1 do
            love.graphics.setColor(values[i][j], values[i][j], values[i][j])     
            love.graphics.rectangle("fill", i, j, 1, 1)
        end
    end

    love.graphics.setCanvas()

    imagedata = canvas:newImageData()
    imagedata:encode("png", "noise" .. generated .. ".png")
end