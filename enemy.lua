function Enemy(level)
    local dice = math.random(1,4)
    local _x, player_y
    local _radius = 20

    if dice == 1 then
        _x = math.random(_radius,love.graphics.getWidth())
        _y = -_radius * 3
    elseif dice == 2 then
        _x = -_radius * 3
        _y = math.random(_radius,love.graphics.getWidth())
    elseif dice == 3 then
        _x = math.random(_radius,love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_radius * 3) + (_radius * 3)
    else
        _x = love.graphics.getWidth() + (_radius * 3)
        _y = math.random(_radius,love.graphics.getWidth())
    end

    return {
        level = level or 1,
        speed = 3,
        radius = _radius,
        x = _x,
        y = _y,
        colorR = math.random(1,100)/100,
        colorG = math.random(1,100)/100,
        colorB =math.random(1,100)/100,

        move = function (self, player_x, player_y)
            if player_x - self.x > 0 then
                self.x = self.x + self.level + self.speed
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level - self.speed
            end
            if player_y - self.y > 0 then
                self.y = self.y + self.level + self.speed
            elseif player_y - self.x < 0 then
                self.y = self.y - self.level - self.speed
            end
        end,

        collision = function (self, player_x, player_y, player_r)
            -- player_left = player_x - player_r
            -- player_right = player_x + player_r
            -- player_top = player_y - player_r
            -- player_bot = player_y + player_r

            -- self_left = self.x - self.radius
            -- self_right = self.x + self.radius
            -- self_top = self.y - self.radius
            -- self_bot = self.y + self.radius

            -- if (self_left > player_left) and (self_left < player_right) then 
            --     if (self_top > player_top) and (self_top < player_bot) then
            --         return true
            --     elseif (self_bot > player_top) and (self_bot < player_bot) then
            --         return true
            --     end
            -- elseif (self_right > player_left) and (self_right < player_right) then 
            --     if (self_top > player_top) and (self_top < player_bot) then
            --         return true
            --     elseif (self_bot > player_top) and (self_bot < player_bot) then
            --         return true
            --     end
            -- end
            --better alternative
            return math.sqrt((self.x - player_x) ^2 + (self.y - player_y) ^2) <= player_r * 2
        end,

        draw = function (self)
            love.graphics.setColor(self.colorR,self.colorG,self.colorB)
            love.graphics.circle("fill",self.x,self.y,self.radius + self.level)
            love.graphics.setColor(1,1,1,1)
        end
    }
end

return Enemy