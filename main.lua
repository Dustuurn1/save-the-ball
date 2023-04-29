local enemy = require "enemy"
local button = require "button"

math.randomseed(os.time())

----------------------------------Locals-------------------------------------
local game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    },
    points = 0,
    levelup = 15,
    level = 1
}

local enemies = {}

local buttons = {
    menu_state = {},
    paused_state = {},
    ended_state = {}
}

----------------------------------Main Functions----------------------------------
function love.load()
    love.mouse.setVisible(false)
    load_player()
    load_buttons()
end


function love.update(dt)
    move_player()
    update_running(dt)
    update_menu(dt)
end


function love.draw()
    fps()
    draw_state()
    draw_player()
end


----------------------------------Local Functions----------------------------------
local function changeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state["ended"] = state == "ended"
end

local function startGame()
    changeGameState("running")

    game.points = 0
    game.level = 1
    game.levelup = 15

    table.insert(enemies, 1, enemy())
    enemies = {
        enemy(1)
    }
end

local function resume_game()
    changeGameState("running")

    game.points = game.points
end

local function return_menu()
    changeGameState("menu")
end

local function settings()
    changeGameState("settings")
end
----------------------------------Draw Functions----------------------------------
function draw_state()
    if game.state["menu"] then draw_menu()
    elseif game.state["running"] then draw_running()
    elseif game.state["paused"] then draw_paused()
    elseif game.state["ended"] then draw_ended()
    end
end

function draw_menu()
    buttons.menu_state.play_game:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 120,
    love.graphics.getWidth()/10,12)
    buttons.menu_state.settings:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 70,
    love.graphics.getWidth()/10,12)
    buttons.menu_state.exit_game:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 20,
    love.graphics.getWidth()/10 + 14,12)
end

function draw_player()
    if game.state["running"] then
       love.graphics.circle("fill",player.x,player.y,player.radius)
    else
       love.graphics.circle("fill",player.x,player.y,player.radius/2)
    end
end

function draw_running()
    love.graphics.printf(math.floor(game.points),
    love.graphics.newFont(24),
    0,
    10,
    love.graphics.getWidth(),
    "center")
    for i = 1, #enemies do
        enemies[i]:draw()
    end
end

function draw_paused()
    buttons.paused_state.resume:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 120,
    love.graphics.getWidth()/10,12)
    buttons.paused_state.menu:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 70,
    love.graphics.getWidth()/10,12)
    buttons.paused_state.exit_game:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 20,
    love.graphics.getWidth()/10 + 14,12)
end

function draw_ended()
    love.graphics.printf("Game Over!",
    love.graphics.newFont(36),
    0,
    10,
    love.graphics.getWidth(),
    "center")

    love.graphics.printf(math.floor(game.points),
    love.graphics.newFont(24),
    0,
    50,
    love.graphics.getWidth(),
    "center")

    buttons.ended_state.resume:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 120,
    love.graphics.getWidth()/10,12)
    buttons.ended_state.menu:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 70,
    love.graphics.getWidth()/10,12)
    buttons.ended_state.exit_game:draw(love.graphics.getWidth()/2 - love.graphics.getWidth()/8,
    love.graphics.getHeight()/2 - 20,
    love.graphics.getWidth()/10 + 14,12)
end

function fps()
    love.graphics.printf("FPS: " .. love.timer.getFPS(),
    love.graphics.newFont(16),
    love.graphics.getWidth()-80,
    10,
    love.graphics.getWidth())
end

----------------------------------Load Functions----------------------------------
function load_buttons()
    buttons.menu_state.play_game = button("Play Game",startGame,nil,love.graphics.getWidth()/4,40)
    buttons.menu_state.settings = button("Settings",nil,nil,love.graphics.getWidth()/4,40)
    buttons.menu_state.exit_game = button("Exit",love.event.quit,nil,love.graphics.getWidth()/4,40)
    buttons.paused_state.resume = button("Resume",resume_game,nil,love.graphics.getWidth()/4,40)
    buttons.paused_state.menu = button("Return To Menu",return_menu,nil,love.graphics.getWidth()/4,40)
    buttons.paused_state.exit_game = button("Exit",love.event.quit,nil,love.graphics.getWidth()/4,40)
    buttons.ended_state.resume = button("Retry",startGame,nil,love.graphics.getWidth()/4,40)
    buttons.ended_state.menu = button("Return To Menu",return_menu,nil,love.graphics.getWidth()/4,40)
    buttons.ended_state.exit_game = button("Exit",love.event.quit,nil,love.graphics.getWidth()/4,40)
end

function load_player()
    player = {
        radius = 20,
        x = 30,
        y = 30
    }
end

----------------------------------Update Functions----------------------------------
function update_running(dt)
    if game.state["running"] then
        if love.keyboard.isDown("escape") then
            changeGameState("paused")
        end 
        for i = 1, #enemies do
            enemies[i]:move(player.x,player.y)
            if enemies[i]:collision(player.x,player.y,player.radius) then
                changeGameState("ended")
            end
        end
        if game.points >= game.levelup then
            game.levelup = game.levelup*2
            game.level = game.level + 1
            table.insert(enemies, 1, enemy(game.level))
        end
        game.points = game.points + (dt*game.level)
    end
end

function update_menu(dt)
    if not game.state["running"] then
        if game.state['menu'] then
            for index in pairs(buttons.menu_state) do
                buttons.menu_state[index]:checkHover(player.x, player.y, player.radius)
            end
        elseif game.state["paused"] then
            for index in pairs(buttons.paused_state) do
                buttons.paused_state[index]:checkHover(player.x, player.y, player.radius)
            end
        elseif game.state["ended"] then
            for index in pairs(buttons.ended_state) do
                buttons.ended_state[index]:checkHover(player.x, player.y, player.radius)
            end
        end
    end
end

function move_player(dt)
    player.x, player.y = love.mouse.getPosition()
end

----------------------------------Other Functions----------------------------------
function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state['menu'] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(player.x, player.y, player.radius)
                end
            elseif game.state["paused"] then
                for index in pairs(buttons.paused_state) do
                    buttons.paused_state[index]:checkPressed(player.x, player.y, player.radius)
                end
            elseif game.state["ended"] then
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(player.x, player.y, player.radius)
                end
            end
        end
    end
end

