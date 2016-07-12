local ffi = require 'ffi'
local gl = require 'ffi.OpenGL'
local class = require 'ext.class'
local Tex1D = require 'gl.tex1d'

local GradientTex = class(Tex1D)

function GradientTex:init(w, colors)
	self.colors = colors
	
	local channels = 4
	local data = ffi.new('unsigned char[?]', w*channels)
	for i=0,w-1 do
		local f = (i+.5)/w
		f = f * #self.colors
		local ip = math.floor(f)
		local fn = f - ip
		local fp = 1 - fn
		local n1 = ip+1
		local n2 = n1%#self.colors + 1
		local c1 = self.colors[n1]
		local c2 = self.colors[n2]
		for j=1,4 do
			local c = c1[j] * fp + c2[j] * fn
			data[j-1+channels*i] = math.floor(255 * c)
		end
	end
	GradientTex.super.init(self, {
		internalFormat = gl.GL_RGBA,
		width = w,
		format = gl.GL_RGBA,
		type = gl.GL_UNSIGNED_BYTE,
		data = data,
		minFilter = gl.GL_LINEAR_MIPMAP_LINEAR,
		magFilter = gl.GL_LINEAR,
		generateMipmap = true,
	})
end

return GradientTex
