local TS = game:GetService("TweenService")


--[[

	-----// OPTIONS DETAILS
	
	
	
	button: the button that the MouseButton1Click event is connected to
	
	uiscale: the UIScale object inside the button (optional)
	
	hoverfunction: a function that will run when the mouse hovers over the button (optional)
	
	unhoverfunction: a function that will run when the mouse leaves the button (optional)
	
	clickfunction: an additional function that will run when the button is clicked, use only for animating since it does not yeild (optional)
		
	maxsize: the maximum size that the UIScale object will scale to (optional)
	
	minsize: the minimum size that the uiscale object will scale to (optional)
	
	soundless: indicates that no sounds should be played

]]


local Default_MaxSize = 1.05
local Default_MinSize = 0.8
local Sound = nil -- Here goes the path of the clicking sound


local function _validateparameters(...)
	local guiobject,clickFunction,options = unpack({...})

	-- Validating guiobject and clickfunction
	if not guiobject or not clickFunction then
		warn("Argument #"..(not guiobject and "1" or "2").." is missing")
		return
	end
	if not guiobject:IsA("GuiObject") then
		warn(guiobject.Name.." must be a GuiObject")
		return
	end
	if typeof(clickFunction) ~= "function" then
		warn("The second parameter must be a callback function")
		return
	end

	-- Validating the options parameter
	if options then
		if options.button and (not options.button:IsA("ImageButton") and not options.button:IsA("TextButton")) then
			warn("options.button for "..guiobject.Name.." must be a TextButton or an ImageButton")
			return
		end
		if options.uiscale and not options.uiscale:IsA("UIScale") then
			warn("options.uiscale "..guiobject.Name.." must be a UIScale Object")
			return
		end
		if options.hoverfunction and typeof(options.hoverfunction) ~= "function" then
			warn("options.hoverfunction "..guiobject.Name.." must be a callback function")
			return
		end
		if options.unhoverfunction and typeof(options.unhoverfunction) ~= "function" then
			warn("options.unhoverfunction "..guiobject.Name.." must be a callback function")
			return
		end
		if options.clickfunction and typeof(options.clickfunction) ~= "function" then
			warn("options.clickfunction "..guiobject.Name.." must be a callback function")
			return
		end
		if options.maxsize and typeof(options.maxsize) ~= "number" then
			warn("options.maxsize "..guiobject.Name.." must be a number")
			return
		end
		if options.minsize and typeof(options.minsize) ~= "number" then
			warn("options.minsize "..guiobject.Name.." must be a number")
			return
		end
	end
	
	-- making sure the clickable guiobject is a type of button
	if not (options and options.button)  and (not guiobject:IsA("TextButton") and not guiobject:IsA("ImageButton")) then
		warn(guiobject.Name.." must either be a TextButton or an ImageLabel or provide a TextButton/Imagelabel object through the options parameter")
		return
	end
	
	return true
end




local module = {}

function module.bouncifyBtn(guiobject:GuiObject ,clickFunction:() -> any, options:{ 
	button: GuiObject?,
	uiscale: UIScale?,
	hoverfunction: (() -> any)?,
	unhoverfunction: (() -> any)?,
	clickfunction: (() -> any)?,
	maxsize: number?,
	minsize: number?,
	soundless: boolean?,
	}?)
	-- validate paramters
	if not _validateparameters(guiobject,clickFunction, options) then
		return
	end

	-- Setting up Variables --
	local button = (options and options.button) or guiobject
	local uiscale = (options and options.uiscale) or guiobject:FindFirstChild("UIScale")
	local hoverfunction = options and options.hoverfunction
	local unhoverfunction = options and options.unhoverfunction
	local clickFunction2 = options and options.clickfunction
	local maxsize = (options and options.maxsize) or Default_MaxSize
	local minsize = (options and options.minsize) or Default_MinSize
	local soundless = options and options.soundless

	-- when the guiobject is hovered on
	guiobject.MouseEnter:Connect(function()
		if uiscale and not guiobject:GetAttribute("Clicked") then
			TS:Create(uiscale,TweenInfo.new(0.2),{Scale = maxsize}):Play()
		end
		if hoverfunction and not guiobject:GetAttribute("Clicked") then
			hoverfunction()
		end
	end)

	-- when the guibject is unhovered
	guiobject.MouseLeave:Connect(function()
		if uiscale then
			TS:Create(uiscale,TweenInfo.new(0.2),{Scale = 1}):Play()
		end
		if unhoverfunction then
			unhoverfunction()
		end
	end)

	-- when the button is clicked
	button.Activated:Connect(function()
		if guiobject:GetAttribute("Clicked") then
			return
		end
		guiobject:SetAttribute("Clicked",true)
		if uiscale then
			TS:Create(uiscale,TweenInfo.new(0.1),{Scale = minsize}):Play()
			task.delay(0.1,function()
				TS:Create(uiscale,TweenInfo.new(0.1,Enum.EasingStyle.Back),{Scale = 1}):Play()
			end)
		end
		if unhoverfunction then
			unhoverfunction()
		end
		if clickFunction2 then
			task.spawn(clickFunction2)
		end
		if not soundless and Sound then
			Sound:Play()
		end
		clickFunction()
		guiobject:SetAttribute("Clicked",false)
	end)
end

return module
