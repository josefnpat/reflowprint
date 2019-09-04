function reflowprint(progress,text,x,y,w,a)
	local font = love.graphics.getFont()
	local width,wrappedtext = font:getWrap(text,w)
	local target = math.floor( math.min(1,math.max(0,progress or 1)) * #text)
	local c_start = 0
	for i,line in pairs(wrappedtext) do
		local c_end = c_start + #line
		local linewidth = font:getWidth(line)
		local offset = 0 -- a == nil or a == "left"
		if a == "center" then
			offset = (w-linewidth)/2
		elseif a == "right" then
			offset = w-linewidth
		end
		-- Determine how much of the line is to be drawn
		local subline
		if c_end < target then -- all
			subline = line
		elseif c_start <= target and target <= c_end then -- partial
			subline = line:sub(1,target-c_start)
		else -- not at all
			break
		end
		love.graphics.print(
			subline,
			x+offset,
			y+font:getHeight()*(i-1)
		)
		c_start = c_end
	end
end

return reflowprint
