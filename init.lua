local trim5 = function(s)
   return s:match'^%s*(.*%S)' or ''
end

local reflow = function(progress,printf,text,x,y,w,a,sx,sy)
	assert(progress)
	assert(printf)
	assert(text)
	assert(x)
	assert(y)
	assert(sx)
	assert(sy)

	local font = love.graphics.getFont()
	local width,wrappedtext = font:getWrap(text,w)

	local target = math.floor( math.min(1,math.max(0,progress or 1)) * #text)
	local c_start = 0
	for i,line in pairs(wrappedtext) do
		local c_end = c_start + #line
		local linewidth = font:getWidth(trim5(line))
		local offset = 0 -- a == nil or a == "left"

		if a == "center" then
			offset = (w-linewidth)/2 * sx
		elseif a == "right" then
			offset = (w-linewidth) * sx
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
		printf(
			subline,
			x+offset,
			y+font:getHeight()*(i-1)*sy,
			0, sx, sy
		)
		c_start = c_end
	end
end

function reflowprint(i,text,x,y,w,a,sx,sy)
	sx = sx or 1
	sy = sy or 1
	if type(i) == "table" then
		reflow(
			i.progress,
			i.print or love.graphics.print,
			i.text,i.x,i.y,i.w,i.a,i.sx,i.sy
		)
	else
		reflow(i,love.graphics.print,text,x,y,w,a,sx,sy)
	end
end

return reflowprint
