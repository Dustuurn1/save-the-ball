function Button(text, func, func_param, width, height)

return {
    _width = width or 100,
    _height = height or 100,
    _func = func or function() print("This button has no function attached") end,
    _func_param = func_param,
    _text = text or "Button",
    button_x = 0,
    button_y = 0,
    text_x = 0,
    text_y = 0,
    colorR = 0.3,
    colorG = 0.6,
    colorB = 0.3,

    checkHover = function (self, mouse_x, mouse_y, cursor_radius)
        if (mouse_x >= self.button_x) and 
        (mouse_x  <= self.button_x + self._width) then
            if (mouse_y  >= self.button_y) and 
            (mouse_y  <= self.button_y + self._height) then
                self.colorR = 0.4
                self.colorG = 0.7
                self.colorB = 0.4
                --return true
            else
                self.colorR = 0.3
                self.colorG = 0.6
                self.colorB = 0.3
            end
        end
    end,

    checkPressed = function (self, mouse_x, mouse_y, cursor_radius)
        if (mouse_x + cursor_radius >= self.button_x) and 
        (mouse_x - cursor_radius <= self.button_x + self._width) then
            if (mouse_y + cursor_radius >= self.button_y) and 
            (mouse_y - cursor_radius <= self.button_y + self._height) then
                if self._func_param then
                    self._func(self._func_param)
                else
                    self._func()
                end
            end
        end
    end,

    draw = function (self,button_x,button_y,text_x,text_y)
        self.button_x = button_x or self.button_x
        self.button_y = button_y or self.button_y

        if text_x then
            self.text_x = text_x + self.button_x
        else
            self.text_x = self.button_x
        end

        if text_y then
            self.text_y = text_y + self.button_y
        else
            self.text_y = self.button_y
        end

        love.graphics.setColor(self.colorR,self.colorG,self.colorB)
        love.graphics.rectangle("fill",self.button_x,self.button_y,self._width,self._height)

        love.graphics.setColor(0,0,0)
        love.graphics.print(self._text,self.text_x,self.text_y)

        love.graphics.setColor(1,1,1)
    end
}
end

return Button