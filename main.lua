utf8 = require"utf8"

reflowprint = require"init"

scalex,scaley = 1,1
alignment = "center"

function badprint(progress,text,x,y,w,a,sx,sy)
	local t = text:sub(1, #text*progress)
	love.graphics.printf(t,x,y,w,a,0,sx,sy)
end

local letters_per_second = 25

function love.load()
	defaultFont = love.graphics.newFont()
	newFont = love.graphics.newFont(48)
	dt = 0
	t = 1
	text="The quick brown fox jumped over the lazy dog."
end

function love.update(dt)
	dt = math.min(t,dt + 1)
end

function love.draw()
	dt = dt + love.timer.getDelta()
	love.window.setTitle("ScaleX: "..scalex.." ScaleY: "..scaley.." Alignment: "..alignment.." Text: "..text)

	local rpx,rpy,rpw,rph = 32,32,love.graphics.getWidth()/2-64,9000
	local bpx,bpy,bpw,bph = love.graphics.getWidth()/2+32,32,love.graphics.getWidth()/2-64,9000

	love.graphics.print("ReflowPrint",rpx,rpy-16)
	love.graphics.print("BadPrint",bpx,bpy-16)

	love.graphics.setFont(newFont)

	love.graphics.rectangle("line",rpx,rpy,rpw,rph)
	reflowprint(dt/t,text,rpx,rpy,rpw,alignment,scalex,scaley)

	love.graphics.rectangle("line",bpx,bpy,bpw,bph)
	badprint(dt/t,text,bpx,bpy,bpw,alignment,scalex,scaley)

	love.graphics.setFont(defaultFont)
	love.graphics.line(0,0,love.graphics.getWidth()*dt/t,0)
end

function love.textinput(t)
	text = text .. t
end

function love.keypressed(key)
	dt = 0
	if key == "backspace" then
		local byteoffset = utf8.offset(text, -1)
		if byteoffset then
			text = string.sub(text, 1, byteoffset - 1)
		end
	end
	if key == "left" then
		scalex = scalex/2
	elseif key == "right" then
		scalex = scalex*2
	elseif key == "up" then
		scaley = scaley/2
	elseif key == "down" then
		scaley = scaley*2
	elseif key == "space" then
		if alignment == "left" then
			alignment = "center"
		elseif alignment == "center" then
			alignment = "right"
		else--if alignment == "right" then
			alignment = "left"
		end
	end
end
